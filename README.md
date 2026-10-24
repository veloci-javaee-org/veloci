# Veloci

Veloci is a Java EE e-commerce web application for browsing products, managing a shopping cart, placing orders, and administering products, categories, customers, and orders.

The application uses Jakarta Servlets, JSP/JSTL, JDBC, and MySQL. It is structured as a traditional servlet-based web application and is configured to run on Apache Tomcat 10.

## Features

### Customer features

- Browse products and filter by category or search term
- View product details
- Create an account and log in
- Add products to a session-based cart
- Select sizes for clothing products
- Checkout with shipping details
- Place orders and view order history
- View order details and order status
- View a customer profile

### Administrator features

- Admin dashboard
- Product creation, editing, deletion, stock updates, and image management
- Category creation, editing, and deletion
- View all customers
- View a customer profile and that customer's order history
- View all orders
- View order details
- Update order status

## Technology stack

- Java 21
- Jakarta Servlet 5
- JSP and JSTL
- JDBC
- MySQL
- Apache Tomcat 10
- Bootstrap and Font Awesome via CDN

The repository currently contains an Eclipse web-project configuration and does not include a Maven `pom.xml` or Gradle build file.

## Project structure

```text
src/main/java/
├── dao/          Database access interfaces and JDBC implementations
├── database/     Database connection setup
├── dto/          Request DTOs
├── enums/        Roles and order statuses
├── exceptions/   Application-specific exceptions
├── filter/       Authentication and authorization filter
├── listeners/    Application startup and database seed listeners
├── mapper/       ResultSet and DTO-to-model mapping
├── models/       Domain models
├── service/      Application and business services
├── servlet/      HTTP endpoints
└── util/         Password hashing and image helpers

src/main/webapp/
├── WEB-INF/
│   ├── lib/      Bundled JDBC and JSTL dependencies
│   ├── views/    Protected JSP and HTML views
│   └── web.xml   Application and database configuration
└── images/       Product images
```

Views are under `WEB-INF/views` so they cannot be requested directly by a browser. Servlets load the required data and forward requests to the appropriate view.

## Main routes

### Public and customer routes

| Method | Route | Purpose |
|---|---|---|
| GET | `/home` | Store home page |
| GET | `/products` | Product listing |
| GET | `/search` | Product search |
| GET | `/product-details?id=...` | Product details |
| GET/POST | `/login` | Login |
| GET/POST | `/signup` | Customer registration |
| GET | `/profile` | Customer profile |
| GET/POST | `/cart` | View and update the cart |
| GET | `/checkout` | Checkout page |
| POST | `/PlaceOrder` | Create an order |
| GET | `/orders` | Customer order history |
| GET | `/order-details?id=...` | Customer order details |
| GET | `/order-success` | Order confirmation |
| POST | `/logout` | End the current session |

### Administrator routes

All routes beginning with `/admin` require an authenticated user with the `ADMIN` role.

| Method | Route | Purpose |
|---|---|---|
| GET | `/admin` | Admin dashboard |
| GET/POST | `/admin/products` | Manage products |
| GET/POST | `/admin/categories` | Manage categories |
| GET | `/admin/customers` | List customers |
| GET | `/admin/customer-details?id=...` | Customer details and order history |
| GET | `/admin/orders` | List orders |
| GET/POST | `/admin/order-details?id=...` | Order details and status updates |

The authorization filter also protects `/test-db` as an admin-only endpoint.

## Prerequisites

Install or configure the following before running the application:

1. Java 21
2. Apache Tomcat 10
3. MySQL Server
4. A database named `ecommerce_db`
5. The application's required database tables

The application expects tables for users, customers, categories, products, product images, orders, and order items. A schema or migration script is not currently included in the repository, so the database schema must be created separately before startup.

## Configuration

Database connection parameters are currently defined in [`src/main/webapp/WEB-INF/web.xml`](src/main/webapp/WEB-INF/web.xml):

```xml
<context-param>
    <param-name>db.url</param-name>
    <param-value>jdbc:mysql://localhost:3306/ecommerce_db</param-value>
</context-param>
<context-param>
    <param-name>db.user</param-name>
    <param-value>root</param-value>
</context-param>
<context-param>
    <param-name>db.password</param-name>
    <param-value>CHANGE_ME</param-value>
</context-param>
```

Replace the database user and password with values appropriate for the local environment. Do not commit production credentials to source control.

At application startup:

- [`AppContextListener`](src/main/java/listeners/AppContextListener.java) initializes the JDBC connection configuration.
- [`SeedDataListener`](src/main/java/listeners/SeedDataListener.java) inserts initial users, customers, categories, products, and product-image links when the relevant tables are empty.

The seed listener contains development credentials and sample data. Review or change those values before using the application outside a local development environment.

## Running with Eclipse and Tomcat

1. Import the repository as an existing Eclipse Dynamic Web Project.
2. Configure a Java 21 JRE.
3. Configure an Apache Tomcat 10 runtime.
4. Add the project to the Tomcat server.
5. Create and configure the `ecommerce_db` MySQL database.
6. Update the database context parameters in `WEB-INF/web.xml`.
7. Start Tomcat and open:

   ```text
   http://localhost:8080/Veloci/
   ```

The welcome route is `/home`, so the application redirects the root context to the store home page through the configured welcome file.

## Authentication and authorization

Authentication is handled by [`Login`](src/main/java/servlet/Login.java) and [`UserService`](src/main/java/service/UserService.java).

- Passwords are hashed using [`PasswordHasher`](src/main/java/util/PasswordHasher.java).
- Successful login data is stored in the HTTP session.
- Sessions expire after 30 minutes of inactivity.
- [`AuthorizationFilter`](src/main/java/filter/AuthorizationFilter.java) protects customer-only and admin-only routes.
- Admin routes require `RoleEnum.ADMIN`.
- Customer operations such as checkout, cart actions, and customer order pages require `RoleEnum.CUSTOMER`.

## Order flow

1. A customer adds products to the session cart.
2. The checkout servlet calculates the subtotal, shipping, and total.
3. `PlaceOrder` validates the request and delegates order creation.
4. `OrderDaoImpl` creates the order and order items in a transaction.
5. Product stock is reduced as part of the same transaction.
6. The customer is redirected to `/order-success`.
7. An administrator can inspect the order and update its status.

Supported order statuses:

```text
PENDING
CONFIRMED
SHIPPED
DELIVERED
CANCELLED
```

## Dependencies

The following libraries are bundled under `src/main/webapp/WEB-INF/lib`:

- MySQL Connector/J
- PostgreSQL JDBC driver
- Jakarta JSTL API
- Jakarta JSTL implementation

The application currently initializes the MySQL driver. The PostgreSQL driver is present but is not the active database configuration.

## Troubleshooting

### `DBConnection was not initialized`

Verify that:

- The application is running in Tomcat.
- `AppContextListener` was discovered.
- The database context parameters exist in `WEB-INF/web.xml`.
- The MySQL JDBC driver is available under `WEB-INF/lib`.

### Database connection failures

Check that:

- MySQL is running.
- `ecommerce_db` exists.
- The configured database user has access.
- The configured port and credentials are correct.

### Missing table errors during startup

Create the required database schema before starting the application. The seed listener inserts data but does not create tables.

### JSP or JSTL errors

Confirm that the JSTL API and implementation JARs remain in `WEB-INF/lib` and that the project is deployed as a web application rather than run as a standalone Java class.

## Development notes

- Database access is implemented with JDBC DAOs and prepared statements.
- Business coordination is handled by service classes.
- JSP pages use JSTL and Expression Language for rendering.
- Product images are served from `src/main/webapp/images/products`.
- Compiled output under `build/` is generated project output and should not be edited manually.
