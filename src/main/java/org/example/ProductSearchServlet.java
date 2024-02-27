package org.example;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;



public class ProductSearchServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve the search query from the request
        String searchQuery = request.getParameter("search");

        // Here, you would typically query the database for products matching the search query.
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";

        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            if (connection == null) {
                System.out.println("Failed to connect to the database");
            }

            String query = "SELECT itemId, itemName, itemDescription, itemPrice FROM items WHERE itemName LIKE ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, "%" + searchQuery + "%");
                preparedStatement.executeUpdate();



            response.sendRedirect("searchResults.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to fetch product data from the database.");
        }
    }
}

