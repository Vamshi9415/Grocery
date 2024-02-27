package org.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("username");

        if (session.getAttribute("username") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int item_Id = Integer.parseInt(request.getParameter("itemId"));
        int item_quantity = Integer.parseInt(request.getParameter("quantity"));

        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";
        String insertQuery = "INSERT INTO cart (itemId, buyerEmail, NumOfItems) VALUES (?, ?, ?)";
        String updateQuery = "UPDATE cart SET NumOfItems = NumOfItems + ? WHERE itemId = ? AND buyerEmail = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection(url, username, password)) {
                // Check if the item exists in the cart
                String checkQuery = "SELECT * FROM cart WHERE itemId = ? AND buyerEmail = ?";
                try (PreparedStatement checkStatement = connection.prepareStatement(checkQuery)) {
                    checkStatement.setInt(1, item_Id);
                    checkStatement.setString(2, user);
                    ResultSet resultSet = checkStatement.executeQuery();

                    if (resultSet.next()) {
                        // Item already in cart, update the quantity
                        try (PreparedStatement preparedStatement = connection.prepareStatement(updateQuery)) {
                            preparedStatement.setInt(1, item_quantity);
                            preparedStatement.setInt(2, item_Id);
                            preparedStatement.setString(3, user);

                            int rowsUpdated = preparedStatement.executeUpdate();
                            if (rowsUpdated > 0) {
                                System.out.println("Data updated successfully");
                            } else {
                                System.out.println("Data update failed");
                            }
                        }
                    } else {
                        // Item not in cart, insert it
                        try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
                            preparedStatement.setInt(1, item_Id);
                            preparedStatement.setString(2, user);
                            preparedStatement.setInt(3, item_quantity);

                            int rowsInserted = preparedStatement.executeUpdate();
                            if (rowsInserted > 0) {
                                System.out.println("Data inserted successfully");
                            } else {
                                System.out.println("Data insertion failed");
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (ClassNotFoundException ex) {
            throw new RuntimeException(ex);
        }

        response.sendRedirect("cartresults.jsp");
    }
}
