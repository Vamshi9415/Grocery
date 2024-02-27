package org.example;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

import static java.lang.System.out;

public class ShopkeeperLoginServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        String email = req.getParameter("Semail");
        String pass_word = req.getParameter("Spassword");

        // Process the login data (check it against the database)
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

            String selectQuery = "SELECT Email, Password FROM ShopkeeperRegistration WHERE Email = ?";

            try (PreparedStatement preparedStatement = connection.prepareStatement(selectQuery)) {
                preparedStatement.setString(1, email);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {
                    String storedEmail = resultSet.getString("Email");
                    String storedPassword = resultSet.getString("Password");

                   /* // Compare the stored email and password with the entered ones
                    if (email.equals(storedEmail) && pass_word.equals(storedPassword)) {
                        // Successful login
                        res.sendRedirect("Store.jsp");
                        return;
                    }else {
                        // Incorrect credentials, set an attribute for error message
                        res.sendRedirect("Login.jsp");
                    }*/
                    if (email.equals(storedEmail) && pass_word.equals(storedPassword)) {
                        // Successful login
                        HttpSession session = req.getSession();
                        session.setAttribute("username", email);
                        res.sendRedirect("item.jsp");
                        return;
                    } else {
                        // Incorrect credentials, set an attribute for error message
                        req.setAttribute("error", "Invalid username or password");
                        RequestDispatcher rd = req.getRequestDispatcher("Login.jsp");
                        rd.forward(req, res);
                    }
                } else {
                    // User not found in the database
                    req.setAttribute("error", "User not found");
                    RequestDispatcher rd = req.getRequestDispatcher("Login.jsp");
                    rd.forward(req, res);
                }
            } catch (ServletException ex) {
                throw new RuntimeException(ex);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
