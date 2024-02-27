<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
    <title>Buyer Transactions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        table {
            border-collapse: collapse;
            width: 80%;
            margin: 20px auto;
            background-color: #fff;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #333;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:nth-child(odd) {
            background-color: #fff;
        }
    </style>

</head>
<body>
<%
    String email = request.getParameter("buyerEmail");
    String url = "jdbc:mysql://localhost:3306/grocery";
    String username = "root";
    String password = "vamshibachu";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        if (connection == null) {
            out.println("Failed to connect to the database");
            return; // Exit if there's no database connection
        }

        String selectQuery = "SELECT itemId, Quantity, transactionTime from transactions WHERE buyerEmail = ?";

        PreparedStatement preparedStatement = connection.prepareStatement(selectQuery);
        preparedStatement.setString(1, email);
        ResultSet resultSet = preparedStatement.executeQuery();
%>
        <h1>Transactions for Buyer: <%= email %></h1>
        <table>
            <tr>
                <th>Item ID</th>
                <th>Quantity</th>
                <th>Transaction Time</th>
            </tr>
<%
        while (resultSet.next()) {
            int itemId = resultSet.getInt("itemId");
            int quantity = resultSet.getInt("Quantity");
            String transactionTime = resultSet.getString("transactionTime");
%>
            <tr>
                <td><%= itemId %></td>
                <td><%= quantity %></td>
                <td><%= transactionTime %></td>
            </tr>
<%
        }
%>
        </table>
<%
        resultSet.close();
        preparedStatement.close();
        connection.close();
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
%>
</body>
</html>
