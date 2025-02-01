# Coffee Shop POS API

This project is a simple Point-of-Sale API for a coffee shop. It lets customers view items (with prices, tax, etc.), create orders (with discounts and tax calculations), and simulate payment (with a background job that notifies orders as complete).

## What’s Inside

- **Items & Promotions:** Models for items (with tax rates) and promotions (e.g., buy a coffee, get a donut discount).
- **Orders:** Create orders, calculate totals (including tax and discounts), and process payments.
- **Notifications:** A background job updates order status from `paid` to `completed` after a short delay.
- **API Endpoints:** List items, create orders, pay for orders, and view order details.
- **Tests:** Minitest tests for models, controllers, and jobs.

## Prerequisites

- [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/)
- Git (optional, for cloning the repo)

## Getting Started

1. **Clone the Repo:**

   ```bash
   git clone https://github.com/yourusername/coffee_shop.git
   cd coffee_shop

2. **Ruby Version:**
    ruby '3.1.6'

3. **Build & Run:**

    We’re using SQLite (so no external DB is needed). The docker-compose.yml is set up

    docker-compose up --build


4. **Run Migrations & seed data:**

    docker-compose run web rails db:migrate
    docker-compose run web rails db:seed


5. **Test the API:**

    -List Items:
        Open your browser or Postman and visit http://localhost:3000/items.

    -Create an Order:
        Send a POST request to http://localhost:3000/orders with a JSON body like:
            {
                "items": [
                    { "item_id": 1, "quantity": 2 },
                    { "item_id": 2, "quantity": 1 }
                ]
            }

    -Pay for an Order:
        POST to http://localhost:3000/orders/1/pay (replace 1 with your order ID).

    -View Order Details:
        GET http://localhost:3000/orders/1.

5. **Run tests:**

    docker-compose run web rails test

6.  **Notifications:**

    Order notifications are simulated via a background job. Once an order is paid, the job (after about 30 seconds) updates its status to completed and logs a message.

7.  **Postman Collection:**

    A sample Postman collection (CoffeeShop.postman_collection.json) is included in the root of the repository. Import it into Postman to quickly test all API endpoints.

