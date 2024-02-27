<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Blob" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results - Bachu's Grocery Store</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h1 {
            text-align: center;
            padding: 20px;
            font-size: 28px;
        }

        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        /* Header styling */
        header {
            background-color: #007bff;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        center {
            text-align: center;
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
<header>Welcome to Bachu's Grocery Store</header>

<center>
    <h1>Search Results</h1>
    <table>
        <tr>
            <th>Item ID</th>
            <th>Item Name</th>
            <th>Description</th>
            <th>Price</th>
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/grocery";
            String username = "root";
            String password = "vamshibachu";
            String searchQuery = request.getParameter("search");
            String query = "SELECT itemId, itemName, itemDescription, itemPrice FROM items WHERE itemName LIKE ?";

            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, "%" + searchQuery + "%");

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    while (resultSet.next()) {
                        int itemId = resultSet.getInt("itemId");
                        String itemName = resultSet.getString("itemName");
                        String itemDescription = resultSet.getString("itemDescription");
                        double itemPrice = resultSet.getDouble("itemPrice");
        %>
        <tr>
            <td><%= itemId %></td>
            <td><%= itemName %></td>
            <td><%= itemDescription %></td>
            <td>$<%= itemPrice %></td>
        </tr>
        <%
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace(); // This will print the full exception stack trace to your server logs.
                throw new RuntimeException("Failed to fetch product data from the database: " + e.getMessage());
            }
        %>
    </table>
</center>
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
