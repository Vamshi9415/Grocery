<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Blob" %>
<%
    int defaultItemsPerPage = 10; // Default number of items to display per page
    int itemsPerPage = defaultItemsPerPage; // Initialize to the default
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bachu's Grocery Store</title>
    <style>
        /* Add any additional CSS styling here */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h1 {
            text-align: center;
            padding: 20px;
            font-size: 28px;
        }

        center {
            text-align: center;
        }

        .header {
            background-color: #007bff;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        .search-form {
            text-align: center;
            margin-top: 20px;
        }

        .search-form input[type="text"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .search-form button {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .search-form button:hover {
            background-color: #0056b3;
        }

        .cart-link {
            margin-top: 20px;
            text-align: center;
        }

        .cart-link a {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
        }

        .cart-link a:hover {
            background-color: #0056b3;
        }

        .item-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .item {
            margin: 20px;
            text-align: center;
            width: 200px;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .item img {
            width: 150px;
            height: 150px;
        }

        .item p {
            margin-top: 10px;
        }

        .item form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .item form input[type="number"] {
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .item form button {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }

        .item form button:hover {
            background-color: #0056b3;
        }
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        .special-footer {
            background-color: #333;
            color: #fff;
            text-align: center;
            padding: 20px 0;
        }

        .footer-content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .copyright, .contact {
            flex: 1;
            margin: 10px;
        }

        .social-links {
            flex: 1;
        }

        .social-links a {
            text-decoration: none;
            margin: 0 10px;
            color: #fff;
        }



    </style>
</head>
<body>
    <div class="header">
        Welcome to Bachu's Grocery Store
    </div>

    <center>
     <% if (session.getAttribute("username") != null) { %>
                <a href="LogoutServlet">Logout</a>
            <% } else { %>
                <a href="Login.jsp">Login</a>
            <% } %>
        <div class="search-form">
                <input type="text" id="search" name="search" placeholder="Search for items" oninput="searchItems()">

        </div>

        <div class="cart-link">
            <% if (session.getAttribute("username") != null) { %>
                      <a href="cartresults.jsp">CART</a>
                  <% } else { %>
                      <a href="Login.jsp">CART</a>
                  <% } %>
        </div>
    </center>
    <div class="userTransactions" style="margin-left:1200px;">
                 <% if (session.getAttribute("username") != null) { %>
                           <a href="userTransactions.jsp">User Transactions</a>
                       <% } else { %>
                           <a href="Login.jsp">User Transactions</a>
                       <% } %>
             </div>
    <!-- Retrieve items from the database and display them -->
    <div class="item-container">
       <form method="get" action="<%= request.getRequestURI() %>">
                <label for="itemsPerPage">Items Per Page:</label>
                <input type="text" id="itemsPerPage" name="itemsPerPage" value="<%= itemsPerPage %>">
                <input type="submit" value="Update">
            </form>


        <%
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "vamshibachu";
        String query = "SELECT * FROM items";
 int currentPage = 1; // Current page number, you can change it as needed

        // Check if a page number is provided in the request
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            currentPage = Integer.parseInt(pageParam);
        }

        // Check if itemsPerPage is specified in the request
        String itemsPerPageParam = request.getParameter("itemsPerPage");
        if (itemsPerPageParam != null) {
            itemsPerPage = Integer.parseInt(itemsPerPageParam);
        }

        // Store itemsPerPage in a session attribute for persistence
        HttpSession userSession = request.getSession();
        userSession.setAttribute("itemsPerPage", itemsPerPage);

        // Retrieve itemsPerPage from session or use the default
        Integer sessionItemsPerPage = (Integer) userSession.getAttribute("itemsPerPage");
        if (sessionItemsPerPage != null) {
            itemsPerPage = sessionItemsPerPage;
        } else {
            itemsPerPage = defaultItemsPerPage;
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            if (connection == null) {
                out.println("Failed to connect to the database");
                return; // Exit if there's no database connection
            }
  int offset = (currentPage - 1) * itemsPerPage;
            String sql = "SELECT * FROM items LIMIT " + itemsPerPage + " OFFSET " + offset;
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                String itemName = resultSet.getString("itemName");
                String itemDescription = resultSet.getString("itemDescription");
                Blob itemImage = resultSet.getBlob("itemImage");
                String itemQuantity = resultSet.getString("itemQuantity");
                String shopkeeperEmail = resultSet.getString("shopkeeperEmail");
                String itemPrice = resultSet.getString("itemPrice");
                int itemId = resultSet.getInt("itemId");

                // Convert Blob to byte array
                byte[] imageDataBytes = itemImage.getBytes(1, (int) itemImage.length());
        %>
            <div class="item">
                <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(imageDataBytes) %>" alt="<%= itemName %>">
                <p><%= itemName %></p>
                <p><%= itemDescription %></p>
                <p>Price: $<%= itemPrice %></p>
                <form action="AddToCartServlet" method="post">
                    <input type="hidden" name="itemId" value="<%= itemId %>">
                    <input type="number" name="quantity" min="1" max="<%= itemQuantity %>" required>
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        <%
            }
            connection.close(); // Close the database connection when done.
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        %>
    </div>

    <div class="pagination">
                <ul>
                    <li><a href="<%= request.getRequestURI() %>?page=<%= currentPage - 1 %>&itemsPerPage=<%= itemsPerPage %>">Previous</a></li>
                    <li><a href="<%= request.getRequestURI() %>?page=<%= currentPage + 1 %>&itemsPerPage=<%= itemsPerPage %>">Next</a></li>
                </ul>
            </div>
     <footer class="special-footer">
            <div class="footer-content">
                <div class="copyright">
                    &copy; 2023 Bachu's Grocery Store'. All rights reserved.
                </div>
                <div class="contact">
                    Contact us at: contact@bachugrocery.com
                </div>
                <div class="social-links">
                    <a href="facebook.com"> Facebook</a>
                    <a href="Twitter.com"> Twitter</a>
                    <a href="instagram.com">Instagram</a>
                </div>
            </div>
        </footer>
        <script>
        function searchItems(){
        	var input = document.getElementById("search");
            var filter = input.value.toLowerCase();
            var items = document.getElementsByClassName("item");

            for (var i = 0; i < items.length; i++) {
                var itemName = items[i].getElementsByTagName("p")[0].textContent.toLowerCase();

                if (itemName.includes(filter)) {
                    items[i].style.display = "block";
                } else {
                    items[i].style.display = "none";
                }
            }
        }
        </script>
</body>
</html>
