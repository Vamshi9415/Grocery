<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOC TYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Buyer Registration</title>
     <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            /* Header styles */
            header {
                background-color: #007bff;
                color: #fff;
                padding: 40px;
                text-align: center;
                font-size: 24px;
                font-weight: bold;
            }

            /* Form container styles */
            .container {
                max-width: 600px;
                margin: 20px auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            /* Form input styles */
            label {
                font-weight: bold;
            }
            input[type="text"],
            input[type="tel"],
            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            /* Button styles */
            button {
                background-color: #4CAF50;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            button:hover {
                background-color: #45a049;
            }

            /* Warning message styles */
            #warning {
                color: red;
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
<center>
<header>Welcome to Bachu's Grocery Store </header>
</center>
    <center>
       <div id="buyer-registration" class="container">
           <form action="BuyerRegistrationServlet" method="post" onsubmit="return validateForm();">
               <label for="FirstName">First name</label>
               <input type="text" name="FirstName" id="FirstName" placeholder="First Name" required><br>
               <label for="LastName">Last name</label>
               <input type="text" name="LastName" id="LastName" placeholder="Last Name" required><br>

               <label for="PhoneNumber">Phone number</label>
               <input type="tel" name="PhoneNumber" pattern="\d{10}" title="Phone number must be a 10-digit number" placeholder="Phone Number" required><br>

               <div id="phoneError" style="color: red;"></div>
               <label for="Email">Email</label>
               <input type="email" name="Email" required>
               <label for="Password">Password</label>
               <input type="password" name="Password" required>
               <label for=""></label>
               <button id="button" type="submit">Register</button><br>
               <div id="warning" style="color: red;"></div>
           </form>
       </div>

    </center>
  <footer class="special-footer">
        <div class="footer-content">
            <div class="copyright">
                &copy; 2023 Bachu Grocery Store. All rights reserved.
            </div>
            <div class="contact">
                Contact us at: contact@bachugroceryStore.com
            </div>
            <div class="social-links">
                <a href="#">Facebook</a>
                <a href="#">Twitter</a>
                <a href="#">LinkedIn</a>
            </div>
        </div>
    </footer>
</body>
<script>
        function validateForm() {
            var firstName = document.getElementById("FirstName").value;
            var lastName = document.getElementById("LastName").value;
            var phoneNumber = document.getElementById("PhoneNumber").value;
            var email = document.getElementsByName("Email")[0].value;
            var password = document.getElementsByName("Password")[0].value;
            var warning = document.getElementById("warning");
            var valid = true;

            // Check if fields are empty
            if (firstName === "" || lastName === "" || phoneNumber === "" || email === "" || password === "") {
                warning.innerHTML = "All fields are required.";
                valid = false;
            }





            return valid;
        }

    </script>
</html>
