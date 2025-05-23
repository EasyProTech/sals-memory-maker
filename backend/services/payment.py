import os
import stripe
from typing import Dict, Optional
from dotenv import load_dotenv

load_dotenv()

stripe.api_key = os.getenv("STRIPE_SECRET_KEY")

class PaymentService:
    def __init__(self):
        self.stripe = stripe

    async def create_payment_intent(self, amount: float, currency: str = "usd") -> Dict:
        """Create a payment intent for the given amount."""
        try:
            intent = self.stripe.PaymentIntent.create(
                amount=int(amount * 100),  # Convert to cents
                currency=currency,
                automatic_payment_methods={"enabled": True},
            )
            return {
                "client_secret": intent.client_secret,
                "id": intent.id
            }
        except Exception as e:
            raise Exception(f"Error creating payment intent: {str(e)}")

    async def create_checkout_session(self, book_id: int, price: float, success_url: str, cancel_url: str) -> Dict:
        """Create a checkout session for the book purchase."""
        try:
            session = self.stripe.checkout.Session.create(
                payment_method_types=["card"],
                line_items=[{
                    "price_data": {
                        "currency": "usd",
                        "product_data": {
                            "name": f"Book Purchase - ID: {book_id}",
                        },
                        "unit_amount": int(price * 100),  # Convert to cents
                    },
                    "quantity": 1,
                }],
                mode="payment",
                success_url=success_url,
                cancel_url=cancel_url,
            )
            return {
                "session_id": session.id,
                "url": session.url
            }
        except Exception as e:
            raise Exception(f"Error creating checkout session: {str(e)}")

    async def handle_webhook(self, payload: bytes, sig_header: str) -> Optional[Dict]:
        """Handle Stripe webhook events."""
        try:
            event = self.stripe.Webhook.construct_event(
                payload, sig_header, os.getenv("STRIPE_WEBHOOK_SECRET")
            )

            if event.type == "payment_intent.succeeded":
                payment_intent = event.data.object
                return {
                    "type": "payment_intent.succeeded",
                    "payment_intent_id": payment_intent.id,
                    "amount": payment_intent.amount / 100,  # Convert from cents
                    "status": payment_intent.status
                }
            elif event.type == "checkout.session.completed":
                session = event.data.object
                return {
                    "type": "checkout.session.completed",
                    "session_id": session.id,
                    "amount": session.amount_total / 100,  # Convert from cents
                    "status": session.status
                }

            return None
        except Exception as e:
            raise Exception(f"Error handling webhook: {str(e)}")

    async def create_publishing_order(self, book_id: int, book_type: str, shipping_address: Dict) -> Dict:
        """Create an order for physical book publishing."""
        try:
            # Create a product for the physical book
            product = self.stripe.Product.create(
                name=f"Physical Book - {book_type}",
                description=f"Physical copy of your personalized {book_type} book"
            )

            # Create a price for the physical book
            price = self.stripe.Price.create(
                product=product.id,
                unit_amount=2999,  # $29.99
                currency="usd"
            )

            # Create a checkout session for the physical book
            session = self.stripe.checkout.Session.create(
                payment_method_types=["card"],
                line_items=[{
                    "price": price.id,
                    "quantity": 1,
                }],
                mode="payment",
                shipping_address_collection={
                    "allowed_countries": ["US", "CA", "GB"],  # Add more countries as needed
                },
                success_url=f"{os.getenv('FRONTEND_URL')}/order/success?session_id={{CHECKOUT_SESSION_ID}}",
                cancel_url=f"{os.getenv('FRONTEND_URL')}/order/cancel",
            )

            return {
                "session_id": session.id,
                "url": session.url
            }
        except Exception as e:
            raise Exception(f"Error creating publishing order: {str(e)}") 