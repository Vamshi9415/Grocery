package org.example;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

public class TransactionServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("username");

        if (session.getAttribute("username") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";
        String query = "insert into transactions (itemId,buyerEmail,Quantity) select itemId,buyerEmail,NumOfItems from cart ;";
        String printQuery = "select items.itemName,transactions.Quantity,items.itemImage, items.itemPrice,(transactions.Quantity*items.itemPrice) as Total_Price  from transactions inner join items on transactions.itemId=items.itemId inner join cart on transactions.itemId=cart.itemId;";
        String deleteQuery = "delete from cart where itemId in (Select itemId from transactions);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // insert into transactions
            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                int rowsInserted = preparedStatement.executeUpdate();
                if (rowsInserted > 0) {
                    System.out.println("Data inserted successfully");
                } else {
                    System.out.println("Data insertion failed");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement preparedStatement = connection.prepareStatement(printQuery)) {
                ResultSet resultSet = preparedStatement.executeQuery();

                String itemName = resultSet.getString("itemName");
                int Quantity = resultSet.getInt("Quantity");
                Blob itemImage = resultSet.getBlob("itemImage");
                int itemPrice = resultSet.getInt("itemPrice");
                int Total_price = resultSet.getInt("Total_price");
                // Convert Blob to byte array
                byte[] imageDataBytes = itemImage.getBytes(1, (int) itemImage.length());

             /*    <div class="cart-item">
                <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(imageDataBytes) %>" alt="<%= itemName %>">
                        <div>
                            <p><%= itemName %></p>
                            <p><%= itemDescription %></p>
                            <p>Price: $<%= itemPrice %></p>
                            <p>Item Quantity: <%= itemQuantity %></p>
                        </div>
                    </div>*/

            } catch (SQLException e) {
                e.printStackTrace();
            }
            try (Connection connection = DriverManager.getConnection(url,username,password)){
            PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery);
                int rowsDeleted = preparedStatement.executeUpdate();

                if (rowsDeleted > 0) {
                    System.out.println(rowsDeleted + " row(s) deleted successfully.");
                } else {
                    System.out.println("No rows were deleted.");
                }
            }catch (SQLException e){
                e.printStackTrace();
            }
        } catch (ClassNotFoundException ex) {
            throw new RuntimeException(ex);
        }


    }
}
