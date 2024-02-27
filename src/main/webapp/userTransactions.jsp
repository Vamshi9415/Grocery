<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.ParseException" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction Results</title>
    <style>
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
    </style>
</head>
<body>
    <center>
        <h1>Transaction Results</h1>
    </center>
    <%
    String buyerEmail = (String) session.getAttribute("username");
    %>
    <h1>Your Transactions</h1>
    <table>
        <tr>
            <th>itemQuantity</th>
            <th>itemName</th>
            <th>quantity</th>
            <th>itemPrice</th>
            <th>totalPrice</th>
        </tr>
        <%
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");



        String query = "SELECT  items.itemQuantity, items.itemName, transactions.Quantity, items.itemPrice, (transactions.Quantity * items.itemPrice) AS Total_Price " +
                       "FROM transactions " +
                       "INNER JOIN items ON transactions.itemId = items.itemId " +
                       "WHERE transactions.buyerEmail = ? ;";

        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {


            preparedStatement.setString(1, buyerEmail);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    String itemQuantity = resultSet.getString("itemQuantity");
                    String itemName = resultSet.getString("itemName");
                    String quantity = resultSet.getString("Quantity");
                    String itemPrice = resultSet.getString("itemPrice");
                    String totalPrice = resultSet.getString("Total_Price");

        %>
        <tr>
            <td><%= itemQuantity %></td>
            <td><%= itemName %></td>
            <td><%= quantity %></td>
            <td>$<%= itemPrice %></td>
            <td>$<%= totalPrice %></td>

        </tr>
        <%
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle database errors
        }
        %>
    </table>
</body>
</html>
