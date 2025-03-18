<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "javax.mail.*" %>
<%@ page import = "javax.mail.internet.*" %>
<html>
<head>
    <title>Newsletter Subscription</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url('https://wallpaperaccess.com/download/newsletter-9844748') no-repeat center center fixed;
            background-size: cover;
            text-align: center;
            color: white;
        }
        .container {
            margin-top: 100px;
            background: rgba(0, 0, 0, 0.8);
            padding: 40px;
            border-radius: 10px;
            display: inline-block;
            box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.3);
        }
        h1 {
            font-size: 28px;
            margin-bottom: 20px;
            color: #ffcc00;
            text-shadow: 2px 2px 10px rgba(255, 204, 0, 0.8);
        }
        input[type="email"] {
            width: 320px;
            height: 45px;
            font-size: 18px;
            padding: 8px;
            border-radius: 5px;
            border: none;
            outline: none;
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transition: 0.3s;
        }
        input[type="email"]::placeholder {
            color: #ccc;
        }
        input[type="email"]:focus {
            background: rgba(255, 255, 255, 0.2);
        }
        input[type="submit"] {
            width: 180px;
            height: 50px;
            font-size: 18px;
            font-weight: bold;
            color: white;
            background: linear-gradient(45deg, #ff6600, #ff3300);
            border: none;
            border-radius: 8px;
            margin: 10px;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 2px 2px 10px rgba(255, 102, 0, 0.5);
        }
        input[type="submit"]:hover {
            background: linear-gradient(45deg, #ff3300, #ff6600);
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1> Newsletter Subscription </h1>
        <form method="post">
            <input type="email" name="email" placeholder="Enter Email here" required/>
            <br><br>
            <input type="submit" name="btn1" value="Subscribe"/>
            <input type="submit" name="btn2" value="Unsubscribe"/>
            <br><br>
        </form>

        <%
        String email = request.getParameter("email");
        Connection con = null;
        if(email != null) {
            try {
                DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
                String url = "jdbc:mysql://localhost:3306/NewsLetterDB";
                con = DriverManager.getConnection(url, "root", "abc123");
                
                if(request.getParameter("btn1") != null) {
                    String sql = "INSERT INTO subscribers(email) VALUES(?)";
                    PreparedStatement pst = con.prepareStatement(sql);
                    pst.setString(1, email);
                    pst.executeUpdate();
                    out.println("<p style='color: lightgreen;'> RECORD ADDED</p>");
                    sendEmail(email, "Congratulations! You have subscribed to the newsletter.");
                } 
                
                if(request.getParameter("btn2") != null) {
                    String sql = "DELETE FROM subscribers WHERE email = ?";
                    PreparedStatement pst = con.prepareStatement(sql);
                    pst.setString(1, email);
                    int rows = pst.executeUpdate();
                    if(rows > 0) {
                        out.println("<p style='color: lightblue;'> EMAIL UNSUBSCRIBED</p>");
                        sendEmail(email, "Sorry to see you go! You have unsubscribed from the newsletter.");
                    } else {
                        out.println("<p style='color: red;'> NO RECORD FOUND</p>");
                    }
                }
                
            } catch(SQLException e) {
                out.println("<p style='color: yellow;'>ISSUE: " + e + "</p>");
            } finally {
                if(con != null) con.close();
            }
        }
        %>
    </div>
</body>
</html>

<%! 
public void sendEmail(String recipient, String messageText) {
    try {
        Properties p = new Properties();
        p.put("mail.smtp.host", "smtp.gmail.com");
        p.put("mail.smtp.port", "587");
        p.put("mail.smtp.auth", "true");
        p.put("mail.smtp.starttls.enable", "true");
        
        Session session = Session.getInstance(p, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("shindearyan872@gmail.com", "lrngilcvsxgemhdb");
            }
        });
        
        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress("shindearyan872@gmail.com"));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        msg.setSubject("Newsletter Subscription");
        msg.setText(messageText);
        Transport.send(msg);
    } catch(Exception e) {
        e.printStackTrace();
    }
}
%>
