<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
<style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        h1 {
            color: #333;
            margin: 20px;
        }

        h2 {
            color: #333;
        }

        form {
            background-color: #fff;
            width: 300px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        input[type="submit"] {
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
    <
    <h2>Buyer Information</h2>
    <form action="retrieveBuyerServlet.jsp" method="post">

            <select name="buyerEmail" required>
            <option value="" disabled selected>Select Buyer Email</option>
            <%
                String url = "jdbc:mysql://localhost:3306/grocery";
                String username = "root";
                String password = "vamshibachu";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection connection = DriverManager.getConnection(url, username, password);

                    String buildingQuery = "select distinct buyerEmail from transactions";
                    PreparedStatement buildingPreparedStatement = connection.prepareStatement(buildingQuery);

                    ResultSet buildingResultSet = buildingPreparedStatement.executeQuery();

                    while (buildingResultSet.next()) {
                        String buyerEmail = buildingResultSet.getString("buyerEmail");
            %>
                        <option value="<%= buyerEmail %>"><%= buyerEmail %></option>
            <%
                    }
                    buildingResultSet.close();
                    buildingPreparedStatement.close();
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <br>
        <input type="submit" value="Enter">
    </form>



</body>
</html>
