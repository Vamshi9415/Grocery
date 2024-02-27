package org.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

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
public class ShopkeeperAddServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
       // Process the login data (check it against the database)
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";

        String itemId = req.getParameter("itemId");
        String itemName = req.getParameter("itemName");
        String itemDescription = req.getParameter("itemDescription");
        Part filePart = req.getPart("imageData");
        InputStream imageData = filePart.getInputStream();
        String itemQuantity = req.getParameter("itemQuantity");
        System.out.println(itemQuantity);
        String shopkeeperEmail = req.getParameter("shopkeeperEmail");
        String itemPrice = req.getParameter("itemPrice");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            if(connection == null) {
                out.println("Failed to connect to the database");
                return; // Exit if there's no database connection
            }

            String query = "Insert Into items (itemName,itemDescription,itemImage,itemQuantity,shopkeeperEmail,itemPrice) values (?,?,?,?,?,?)";

            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1,itemName);
            preparedStatement.setString(2,itemDescription);
            preparedStatement.setBlob(3,imageData);
            preparedStatement.setString(4,itemQuantity);
            preparedStatement.setString(5,shopkeeperEmail);
            preparedStatement.setString(6,itemPrice);
            preparedStatement.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        res.sendRedirect("item.jsp");
    }
}
