<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bachu's Grocery Store</title>
<style>
 body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #007bff;
            color: #fff;
            text-align: center;
            padding: 10px 0;
            font-size: 28px;
            font-weight: bold;
        }

        h1 {
            text-align: center;
            font-size: 24px;
            margin: 20px;
        }

        center {
            text-align: center;
        }

        a {
            display: inline-block;
            background-color: #007bff;
            color: #fff;
            text-align: center;
            padding: 10px 20px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 4px;
        }

        a:hover, a:active {
            background-color: #0056b3;
        }

        .item-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .item {
            width: 300px;
            background-color: #fff;
            border: 1px solid #ddd;
            margin: 10px;
            padding: 10px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .item img {
            max-width: 100%;
            height: auto;
        }

        .item p {
            margin: 10px 0;
            font-size: 16px;
        }

        .special-footer {
            background-color: #333;
            color: #fff;
            text-align: center;
            padding: 20px 0;
        }

        .footer-content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .copyright, .contact {
            flex: 1;
            margin: 10px;
        }

        .social-links {
            flex: 1;
        }

        .social-links a {
            text-decoration: none;
            margin: 0 10px;
            color: #fff;
        }
    </style>
</style>
</head>
<body>
<center>
<header>Welcome to Bachu's Grocery Store </header>
</center>
    <center>
        <h1>Cart</h1>
        <h1>Welcome to Bachu's Grocery Store</h1>
        <h1>${pageContext.request.contextPath}</h1>
        <% if (session.getAttribute("username") != null) { %>
            <a href="LogoutServlet">Logout</a>
        <% } else { %>
            <a href="Login.jsp">Login</a>
        <% } %>
    </center>

    <!-- Display items in the cart -->
    <div class="item-container">
        <c:forEach items="${cart}" var="cartItem">
            <%
            int item_Id = cartItem.itemId;
            int item_quantity = cartItem.itemQuantity;
            String url = "jdbc:mysql://localhost:3306/grocery";
            String username = "root";
            String password = "vamshibachu";
            String query = "SELECT * FROM items WHERE itemId = ? AND itemQuantity >= ?";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection connection = DriverManager.getConnection(url, username, password);

                if (connection == null) {
                    out.println("Failed to connect to the database");
                    return; // Exit if there's no database connection
                }

                PreparedStatement preparedStatement = connection.prepareStatement(query);
                preparedStatement.setInt(1, item_Id);
                preparedStatement.setInt(2, item_quantity);
                ResultSet resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    String itemName = resultSet.getString("itemName");
                    String itemDescription = resultSet.getString("itemDescription"); // Retrieve item description
                    double itemPrice = resultSet.getDouble("itemPrice"); // Retrieve item price

                    // Convert Blob to byte array
                    Blob itemImage = resultSet.getBlob("itemImage");
                    byte[] imageDataBytes = itemImage.getBytes(1, (int) itemImage.length());
            %>
            <div class="item">
                <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(imageDataBytes) %>" alt="<%= itemName %>">
                <p><%= itemName %></p>
                <p><%= itemDescription %></p>
                <p>Price: $<%= itemPrice %></p>
                <p>Item Quantity: <%= item_quantity %></p>
            </div>
            <%
                }
                connection.close(); // Close the database connection when done.
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
            }
            %>
        </c:forEach>
    </div>

    <a href="Store.jsp">Continue Shopping</a>
    <footer class="special-footer">
                <div class="footer-content">
                    <div class="copyright">
                        &copy; 2023 Bachu's Grocery Store'. All rights reserved.
                    </div>
                    <div class="contact">
                        Contact us at: contact@bachugrocery.com
                    </div>
                    <div class="social-links">
                        <a href="facebook.com"> Facebook</a>
                        <a href="Twitter.com"> Twitter</a>
                        <a href="instagram.com">Instagram</a>
                    </div>
                </div>
            </footer>
</body>
</html>
