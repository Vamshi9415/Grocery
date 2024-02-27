package org.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class EmptyCartServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Empty cart!!!");
        // Handle empty cart action and delete cart items
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";
        String deleteQuery = "DELETE FROM cart WHERE buyerEmail = ?";

        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("username");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery)) {
                preparedStatement.setString(1, user);
                int rowsDeleted = preparedStatement.executeUpdate();
                if (rowsDeleted > 0) {
                    // Cart emptied successfully
                    System.out.println("Rows Deleted Successfully");
                } else {
                    // No rows were deleted
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (ClassNotFoundException ex) {
            throw new RuntimeException(ex);
        }

        // Move the sendRedirect outside of the try-catch blocks
        response.sendRedirect("cartresults.jsp");
    }
}
