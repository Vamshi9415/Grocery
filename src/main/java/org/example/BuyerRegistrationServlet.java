package org.example;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;


public class BuyerRegistrationServlet extends HttpServlet {


    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Retrieve user registration data from the request
        String firstName = req.getParameter("FirstName");
        String lastName = req.getParameter("LastName");
        String phoneNumber = req.getParameter("PhoneNumber");
        String email = req.getParameter("Email");
        String pass_word = req.getParameter("Password");

        // Process the registration data (e.g., store it in the database)
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            if (connection == null) {
                System.out.println("Failed to connect to the database");
                return; // Exit if there's no database connection
            }

            String insertQuery = "INSERT into buyerRegistration(FirstName,LastName,PhoneNumber,Email,Password) Values (?,?,?,?,?)";

            try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
                preparedStatement.setString(1, firstName);
                preparedStatement.setString(2, lastName);
                preparedStatement.setString(3, phoneNumber);
                preparedStatement.setString(4, email);
                preparedStatement.setString(5, pass_word);

                int rowsAffected = preparedStatement.executeUpdate();
                System.out.println(rowsAffected + " rows inserted.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }


        res.sendRedirect("Login.jsp");
    }
}
