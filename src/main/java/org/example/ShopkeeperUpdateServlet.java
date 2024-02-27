package org.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import jakarta.servlet.http.HttpServlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import static java.lang.System.out;

@MultipartConfig(location = "/")
public class ShopkeeperUpdateServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Process the login data (check it against the database)
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";


        String itemName = req.getParameter("updateItemName");
        String itemQuantity = req.getParameter("updateItemQuantity");
        HttpSession session = req.getSession();
        String shopkeeperEmail = (String)session.getAttribute("username");

        out.println(itemName);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            if (connection == null) {
                out.println("Failed to connect to the database");
                return; // Exit if there's no database connection
            }
            String query = "Update items set  itemQuantity= ? where shopkeeperEmail= ? and itemName = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);

            preparedStatement.setString(1, itemQuantity);
            preparedStatement.setString(2, shopkeeperEmail);
            preparedStatement.setString(3,  itemName );
            preparedStatement.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        res.sendRedirect("item.jsp");
    }
}

