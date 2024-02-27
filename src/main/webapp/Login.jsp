
 <!DOCTYPE html>
<html>

<head>
    <title>Toggle Switch</title>
    <style>
		#login,#signup{
            color: black;
        }
        h1 {
			color: green;
		}
		/* toggle in label designing */
		.toggle {
			position : relative ;
			display : inline-block;
			width : 100px;
			height : 52px;
			background-color: rgb(255, 69, 69);
			border-radius: 30px;
			border: 2px solid rgb(0, 0, 0);
		}
		/* After slide changes */
		.toggle:after {
			content: '';
			position: absolute;
			width: 50px;
			height: 50px;
			border-radius: 50%;
			background-color: #000000;
			top: 1px;
			left: 1px;
			transition: all 0.5s;
		}
		/* Toggle text */
		p {
			font-family: Arial, Helvetica, sans-serif;
			font-weight: bold;
            color: black;
            size: 0.5px;
		}
		/* Checkbox checked effect */
		.checkbox:checked + .toggle::after {
			left : 49px;
		}
		/* Checkbox checked toggle label bg color */
		.checkbox:checked + .toggle {
			background-color: rgb(11, 182, 234);
		}

		/* Checkbox vanished */
		.checkbox {
			display : none;
		}
   .container{
            border: 10px solid black;
            border-radius: 5px ;
            padding: 2px;
        }
        input{
            border: 5px rgb(255, 77, 77);
            border-radius: 2px;
            box-shadow: 2px 2px 5px rgb(119, 119, 119);
        }
        #bResponse,#sResponse{
            font-size: 5px;
        }
        label{
            font-style: normal;
            font-size: 12px;
            font-family:'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
        }

      header {
                        background-color: #007bff; /* Header background color */
                        color: #fff; /* Header text color */
                        padding: 10px 0;
                        text-align: center;
                        font-size: 24px; /* Adjust font size as needed */
                        font-weight: bold; /* Adjust font weight as needed */
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
    <div class="header">
        <center>
            <h1>LOGIN</h1>
        </center>

    </div>
    <div class="container">
        <center>
            <input type="checkbox" id="switch" class="checkbox" />
            <label for="switch" class="toggle"></label>
            <p id="p">Shopkeeper</p>
            <div id="buyer" class="buyer">
                <form action="BuyerLoginServlet" method="post">
                    <label for="email">Email</label><br>
                    <input type="email" id="email" name="Bemail"><br>
                    <label for="password">Password</label><br>
                    <input type="password" id="password" name="Bpassword"><br>
                     <button id="loginbButton"> Login </button>
                      <p id="error" style="color: red;">
                                                     <c:if test="${not empty requestScope.error}">
                                                         ${requestScope.error}
                                                     </c:if>
                                                 </p>
                    <p id="bResponse">If you don't have an account</p>
                    <a href="Buyer.jsp">Sign up</a><br>
                </form>
            </div>

            <div id="shopkeeper" class="shopkeeper">
                <form action="ShopkeeperLoginServlet" method="post">
                    <label for="email">Email</label><br>
                    <input type="email" id="email" name="Semail" required><br>
                    <label for="password">Password</label><br>
                    <input type="password" id="password" name="Spassword" required><br>
                    <button id="loginsButton"> Login </button>
                    <p id="error" style="color: red;">
                                <c:if test="${not empty requestScope.error}">
                                    ${requestScope.error}
                                </c:if>
                            </p>
                    <p id="sResponse">If you don't have an account</p>
                    <a href="Shopkeeper.jsp">Sign up</a><br>
                </form>
            </div>
        </center>
    </div>

    <script>
const loginbButton = document.getElementById("loginbButton");
        const loginsButton = document.getElementById("loginsButton");

      const toggle = document.getElementById("switch");
            const label = document.getElementById("p");
            let buyer = document.querySelector("#buyer");
            let shopkeeper = document.querySelector("#shopkeeper");
            buyer.style.display = "none";
            toggle.addEventListener('change', function() {
                if (toggle.checked) {
                    label.textContent = "Buyer";
                    shopkeeper.style.display = "none";
                    buyer.style.display = "block";

                } else {
                    label.textContent = "Shop keeper";
                    buyer.style.display = "none";
                    shopkeeper.style.display = "block";

                }
            });
 // Function to validate the buyer login form
        function validateBuyerForm() {
            var email = document.getElementById("buyerEmail").value;
            var password = document.getElementById("buyerPassword").value;
            var buyerError = document.getElementById("buyerError");
            var valid = true;

            if (email === "" || password === "") {
                buyerError.textContent = "All fields are required.";
                valid = false;
            }

            return valid;
        }

        // Function to validate the shopkeeper login form
        function validateShopkeeperForm() {
            var email = document.getElementById("shopkeeperEmail").value;
            var password = document.getElementById("shopkeeperPassword").value;
            var shopkeeperError = document.getElementById("shopkeeperError");
            var valid = true;

            if (email === "" || password === "") {
                shopkeeperError.textContent = "All fields are required.";
                valid = false;
            }

            return valid;
        }
          loginbButton.addEventListener("click", function () {
                    var isValid = validateBuyerForm();
                    if (!isValid) {
                        return false; // Prevent form submission if validation fails
                    }
                    document.getElementById("buyerForm").submit();
                });

                loginsButton.addEventListener("click", function () {
                    var isValid = validateShopkeeperForm();
                    if (!isValid) {
                        return false; // Prevent form submission if validation fails
                    }
                    document.getElementById("shopkeeperForm").submit();
                });
    </script>
</body>

</html>


