<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Blob" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bachu's Grocery Store - Cart</title>
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
            padding: 40px ;
            font-size: 28px;
            font-weight: bold;
        }

        center {
            text-align: center;
            margin: 20px;
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

        .cart-item {
            width: 300px;
            background-color: #fff;
            border: 1px solid #ddd;
            margin: 10px;
            padding: 10px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
        }

        .cart-item img {
            max-width: 100%;
            height: auto;
        }

        .cart-item div {
            text-align: left;
        }

        .cart-item p {
            margin: 10px 0;
            font-size: 16px;
        }

        button {
            background-color: #ff4d4d;
            color: #fff;
            text-align: center;
            padding: 10px 20px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #ff0000;
        }

        footer {
            background-color: #333;
            color: #fff;
            text-align: center;
            padding: 20px ;
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
    <h1>Cart</h1>

    <% if (session.getAttribute("username") != null) { %>
        <a href="LogoutServlet" style="margin-left:80%">Logout</a>
    <% } else { %>
        <a href="Login.jsp" style="margin-right:80%">Login</a>
    <% } %>
</center>



<!-- Display items in the cart -->
<div class="item-container">
    <%
    String url = "jdbc:mysql://localhost:3306/grocery";
    String username = "root";
    String password = "vamshibachu";
    String query = "Select items.itemName,cart.NumOfItems ,items.itemImage, items.itemPrice,items.itemDescription from items inner join cart on items.itemId=cart.itemId;";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        if (connection == null) {
            out.println("Failed to connect to the database");
            return;
        }

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            String itemName = resultSet.getString("itemName");
            String itemQuantity = resultSet.getString("NumOfItems");
            Blob itemImage = resultSet.getBlob("itemImage");
            String itemPrice = resultSet.getString("itemPrice");
            String itemDescription = resultSet.getString("itemDescription");

            // Convert Blob to byte array
            byte[] imageDataBytes = itemImage.getBytes(1, (int) itemImage.length());
    %>
    <div class="cart-item">
        <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(imageDataBytes) %>"
             alt="<%= itemName %>">
        <div>
            <h4><%= itemName %></h4>
            <p><%= itemDescription %></p>
            <p>Price: $<%= itemPrice %></p>
            <p>Item Quantity: <%= itemQuantity %></p>
        </div>
    </div>
    <%
    }
    connection.close(); // Close the database connection when done.
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    %>
</div>

<form action="EmptyCartServlet" method="post" style="margin-bottom:10px">
    <button type="submit" name="EmptyCart">Empty Cart</button>
</form>
<a href="Store.jsp">Continue Shopping</a>
<a href="transactions.jsp" style="margin-left:33%;margin-bottom:10px">Buy now</a>

<br>
<footer>
    <div class="footer-content">
        <div class="copyright">
            &copy; 2023 Bachu's
