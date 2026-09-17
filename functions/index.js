const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { getFirestore } = require("firebase-admin/firestore");
const { initializeApp } = require("firebase-admin/app");
const axios = require("axios");

initializeApp();

const paymobSecretKey = defineSecret("PAYMOB_SECRET_KEY");
const paymobCardId = defineSecret("PAYMOB_CARD_ID");
const paymobWalletId = defineSecret("PAYMOB_WALLET_ID");
const paymobKioskId = defineSecret("PAYMOB_KIOSK_ID");

exports.createPayment = onRequest(
    {
        secrets: [
            paymobSecretKey,
            paymobCardId,
            paymobWalletId,
            paymobKioskId,
        ],
    },
    async (req, res) => {
        try {
            if (req.method !== "POST") {
                return res.status(405).json({
                    success: false,
                    message: "Only POST requests are allowed",
                });
            }

            const {
                eventId,
                ticketTypeId,
                quantity,
                paymentMethod,
            } = req.body;

            if (!eventId || !ticketTypeId || !quantity || !paymentMethod) {
                return res.status(400).json({
                    success: false,
                    message:
                        "eventId, ticketTypeId, quantity and " +
                        "paymentMethod are required",
                });
            }

            if (!Number.isInteger(quantity) || quantity <= 0) {
                return res.status(400).json({
                    success: false,
                    message: "Quantity must be a positive integer",
                });
            }

            const allowedPaymentMethods = [
                "CARD",
                "WALLET",
                "KIOSK",
            ];

            if (!allowedPaymentMethods.includes(paymentMethod)) {
                return res.status(400).json({
                    success: false,
                    message: "Unsupported payment method",
                });
            }

            const db = getFirestore();

            const ticketRef = db
                .collection("events")
                .doc(eventId)
                .collection("ticketTypes")
                .doc(ticketTypeId);

            const ticketSnap = await ticketRef.get();

            if (!ticketSnap.exists) {
                return res.status(404).json({
                    success: false,
                    message: "Ticket type not found",
                });
            }

            const ticket = ticketSnap.data();

            const price = Number(ticket.price);
            const availableQuantity = Number(ticket.availableQuantity);

            console.log("Ticket data:", ticket);
            console.log("availableQuantity raw:", ticket.availableQuantity);
            console.log("availableQuantity type:", typeof ticket.availableQuantity);
            console.log("availableQuantity converted:", availableQuantity);

            if (!Number.isFinite(price) || price <= 0) {
                return res.status(400).json({
                    success: false,
                    message: "Invalid ticket price",
                });
            }

            if (!Number.isInteger(availableQuantity) || availableQuantity < 0) {
                return res.status(400).json({
                    success: false,
                    message: "Invalid available quantity",
                });
            }

            if (availableQuantity < quantity) {
                return res.status(400).json({
                    success: false,
                    message: "Not enough tickets available",
                    availableQuantity,
                });
            }

            const totalAmount = price * quantity;
            const amountInCents = Math.round(totalAmount * 100);

            let integrationId;

            switch (paymentMethod) {
                case "CARD":
                    integrationId = Number(paymobCardId.value());
                    break;

                case "WALLET":
                    integrationId = Number(paymobWalletId.value());
                    break;

                case "KIOSK":
                    integrationId = Number(paymobKioskId.value());
                    break;
            }

            if (!Number.isInteger(integrationId)) {
                return res.status(500).json({
                    success: false,
                    message: "Invalid Paymob integration configuration",
                });
            }

            const orderRef = db.collection("orders").doc();

            await orderRef.set({
                amount: totalAmount,
                eventId,
                paymentMethod,
                quantity,
                status: "PENDING",
                ticketTypeId,
                userId: null,
                createdAt: new Date(),
            });

            const paymobResponse = await axios.post(
                "https://accept.paymob.com/v1/intention/",
                {
                    amount: amountInCents,
                    currency: "EGP",
                    payment_methods: [
                        integrationId,
                    ],
                    items: [
                        {
                            name: ticket.name || "Event Ticket",
                            amount: amountInCents,
                            description: "Event ticket",
                            quantity,
                        },
                    ],
                    billing_data: {
                        apartment: "NA",
                        first_name: "Test",
                        last_name: "Customer",
                        street: "NA",
                        building: "NA",
                        phone_number: "+201000000000",
                        city: "Cairo",
                        country: "EG",
                        email: "test@example.com",
                        floor: "NA",
                        state: "Cairo",
                    },
                    special_reference: orderRef.id,
                },
                {
                    headers: {
                        Authorization: `Token ${paymobSecretKey.value()}`,
                        "Content-Type": "application/json",
                    },
                },
            );

            await orderRef.update({
                paymobIntentionId: paymobResponse.data.id,
                paymobOrderId: paymobResponse.data.intention_order_id,
            });

            return res.status(200).json({
                success: true,
                orderId: orderRef.id,
                amount: totalAmount,
                currency: "EGP",
                paymentMethod,
                clientSecret: paymobResponse.data.client_secret,
            });
        } catch (error) {
            console.error(
                "Create payment error:",
                error.response && error.response.data ?
                    error.response.data :
                    error.message,
            );

            return res.status(500).json({
                success: false,
                message: "Failed to create payment",
                error: error.response && error.response.data ?
                    error.response.data :
                    error.message,
            });
        }
    },
);
