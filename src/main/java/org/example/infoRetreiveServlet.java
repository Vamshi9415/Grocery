package org.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import static java.lang.System.out;

public class infoRetreiveServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException { String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";

        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");

        // Parse user input into java.sql.Date objects
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = null;
        Date endDate = null;

        try {
            startDate = new Date(dateFormat.parse(startDateStr).getTime());
            endDate = new Date(dateFormat.parse(endDateStr).getTime());
        } catch (ParseException e) {
            e.printStackTrace();
            // Handle date parsing errors
        }

        // Write your SQL query to retrieve transactions within the specified date range
        String query = "SELECT items.itemQuantity, items.itemName, transactions.Quantity, items.itemImage, items.itemPrice, (transactions.Quantity * items.itemPrice) AS Total_Price " +
                "FROM transactions " +
                "INNER JOIN items ON transactions.itemId = items.itemId " +
                "WHERE transactions.transactionTime BETWEEN ? AND ?;";

        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setDate(1, new java.sql.Date(startDate.getTime()));
            preparedStatement.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                req.setAttribute("transactionItems", resultSet); // Set the result set as a request attribute
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle database errors
        }

        // Forward the request to your JSP page for rendering
        req.getRequestDispatcher("retreivedata.jsp").forward(req, res);
    }
}
