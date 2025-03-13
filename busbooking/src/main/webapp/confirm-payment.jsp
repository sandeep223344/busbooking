<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ include file="DBConnection.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Payment</title>
    <style>
        body { font-family: 'Poppins', sans-serif; text-align: center; background-color: #f8f9fa; }
        .container { max-width: 600px; margin: 40px auto; padding: 20px; background: #ffffff; 
                     border-radius: 12px; box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.15); }
        h1 { color: #333; }
        .success { color: #28a745; font-size: 20px; font-weight: bold; }
        .error { color: #dc3545; font-size: 18px; }
        .btn { display: inline-block; padding: 12px 20px; font-size: 18px; text-decoration: none; 
               background: #007bff; color: white; border-radius: 8px; transition: background 0.3s ease, transform 0.2s ease; }
        .btn:hover { background: #0056b3; transform: scale(1.05); }
    </style>
</head>
<body>

<div class="container">
    <h1>Payment Confirmation</h1>

    <%
        try {
            // Get database connection
            Connection con = getConnection();

            // Retrieve parameters safely
            String scheduleIdParam = request.getParameter("schedule_id");
            String seatCountParam = request.getParameter("seat_count");
            String amountParam = request.getParameter("amount");
            String paymentMethod = request.getParameter("payment_method");

            if (scheduleIdParam == null || seatCountParam == null || amountParam == null || paymentMethod == null ||
                scheduleIdParam.isEmpty() || seatCountParam.isEmpty() || amountParam.isEmpty() || paymentMethod.isEmpty()) {
    %>
                <p class="error">❌ Error: Missing payment details. Please go back and try again.</p>
                <a href="booking.jsp" class="btn">Retry</a>
    <%
                return;
            }

            int user_id = (Integer) session.getAttribute("user_id");
            int schedule_id = Integer.parseInt(scheduleIdParam);
            int seat_count = Integer.parseInt(seatCountParam);
            double amount = Double.parseDouble(amountParam);

            // Insert payment details into the database
            String sql = "INSERT INTO payments (user_id, schedule_id, seat_count, amount, payment_method) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, user_id);
            pst.setInt(2, schedule_id);
            pst.setInt(3, seat_count);
            pst.setDouble(4, amount);
            pst.setString(5, paymentMethod);

            int rowsInserted = pst.executeUpdate();
            pst.close();

            if (rowsInserted > 0) {
    %>
                <p class="success">Payment Successful! Your booking is confirmed.</p>
                <p> Seats Booked: <%= seat_count %></p>
                <p> Amount Paid: ₹<%= amount %></p>
                <p> Payment Method: <%= paymentMethod %></p>
                <a href="user-dashboard.jsp" class="btn">Go to Dashboard</a>
    <%
            } else {
    %>
                <p class="error"> Payment failed. Please try again.</p>
                <a href="booking.jsp" class="btn">Retry Payment</a>
    <%
            }
        } catch (Exception e) {
    %>
        <p class="error">Error: <%= e.getMessage() %></p>
        <a href="booking.jsp" class="btn">Retry</a>
    <%
        }
    %>
</div>

</body>
</html>
