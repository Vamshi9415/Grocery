<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Blob" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }

        center {
            text-align: center;
        }

        header {
            background-color: #007bff;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        h1 {
            text-align: center;
            font-size: 28px;
        }

        .cart-item {
            display: flex;
            align-items: center;
            margin: 10px;
            padding: 10px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .cart-item img {
            width: 150px;
            height: 150px;
        }

        .cart-item p {
            margin-top: 10px;
        }

        a {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            display: inline-block;
            margin-top: 20px;
        }

        a:hover {
            background-color: #0056b3;
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
</head>
<body>
<center>
    <header>Welcome to Bachu's Grocery Store</header>
</center>
<center>
    <h1>Transaction Result</h1>
</center>

<%
    String url = "jdbc:mysql://localhost:3306/grocery";
    String username = "root";
    String password = "vamshibachu";
    String query = "INSERT INTO transactions (itemId, buyerEmail, Quantity) SELECT itemId, buyerEmail, NumOfItems FROM cart;";
    int itemId=0;
    String printCart = "select items.itemId,items.itemQuantity, items.itemName, cart.NumOfItems, items.itemImage, items.itemPrice, (cart.NumOfItems*items.itemPrice) as Total_price from cart inner join items on cart.itemid=items.itemId;";
    String deleteQuery = "DELETE FROM cart WHERE itemId IN (SELECT itemId FROM transactions);";
    synchronized(session){
    try (Connection connection = DriverManager.getConnection(url, username, password)) {
        connection.setAutoCommit(false);
        connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

        // Insert into transactions
        try (PreparedStatement insertStatement = connection.prepareStatement(query)) {
            int rowsInserted = insertStatement.executeUpdate();
            if (rowsInserted > 0) {
                out.println("Data inserted successfully");
            } else {
                out.println("Data insertion failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Transaction failed. Please try again later.");
        }

        // Select and display transaction items
        try (PreparedStatement selectStatement = connection.prepareStatement(printCart)) {
            ResultSet resultSet = selectStatement.executeQuery();
            boolean itemsUnavailable = false;
            int availableStock = 0;

            while (resultSet.next()) {
                itemId=resultSet.getInt("itemId");
                int itemQuantity = resultSet.getInt("itemQuantity");
                String itemName = resultSet.getString("itemName");
                int quantity = resultSet.getInt("NumOfItems");
                Blob itemImage = resultSet.getBlob("itemImage");
                int itemPrice = resultSet.getInt("itemPrice");
                int totalPrice = resultSet.getInt("Total_Price");

                // Convert Blob to byte array
                byte[] imageDataBytes = itemImage.getBytes(1, (int) itemImage.length());

                if (itemQuantity >= quantity) {
%>
    <div class="cart-item">
        <img src="data:image/jpeg;base64,<%= Base64.getEncoder().encodeToString(imageDataBytes) %>" alt="<%= itemName %>">
        <div>
            <p><%= itemName %></p>
            <p>Price: $<%= itemPrice %></p>
            <p>Item Quantity: <%= quantity %></p>
            <p>Total Price: $<%= totalPrice %></p>
        </div>
    </div>
    <%
        String query2 = "update items inner join cart on items.itemId = cart.itemId Set items.itemQuantity = items.itemQuantity-cart.NumofItems where items.itemQuantity-cart.NumOfItems > 0 and items.itemId=?";

        // Updating the items table
        try (PreparedStatement prepareStatement = connection.prepareStatement(query2)) {
        prepareStatement.setInt(1,itemId);
            prepareStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error updating items table.");
        }
    } else {
        availableStock = itemQuantity;
        itemsUnavailable = true;
    }
            }
            if (itemsUnavailable) {
%>
    <p>Required Quantity is Currently Unavailable </p>
    available Stock: <%= availableStock %> <br>
    <%
    }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error fetching transaction details.");
        }

        // Delete items from the cart
        try (PreparedStatement deleteStatement = connection.prepareStatement(deleteQuery)) {
            int rowsDeleted = deleteStatement.executeUpdate();
            if (rowsDeleted > 0) {
                out.println(rowsDeleted + " row(s) deleted from the cart successfully.");
            } else {
                out.println("No rows were deleted from the cart.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error deleting items from the cart.");
        }
        connection.commit();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    }
%>
<a href="Store.jsp">Continue Shopping</a>
<footer class="special-footer" style="margin-top:450px">
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
