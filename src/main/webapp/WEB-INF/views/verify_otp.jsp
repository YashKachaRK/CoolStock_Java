<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verify OTP - CoolStock</title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #6366f1;
                --primary-hover: #4f46e5;
                --glass: rgba(255, 255, 255, 0.1);
                --glass-border: rgba(255, 255, 255, 0.2);
                --text: #ffffff;
            }

            body {
                font-family: 'Outfit', sans-serif;
                background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
                color: var(--text);
                overflow: hidden;
            }

            .container {
                background: var(--glass);
                backdrop-filter: blur(12px);
                border: 1px solid var(--glass-border);
                padding: 2.5rem;
                border-radius: 24px;
                width: 100%;
                max-width: 400px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
                animation: fadeIn 0.6s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h2 {
                margin-bottom: 0.5rem;
                font-weight: 600;
                text-align: center;
            }

            p {
                color: #94a3b8;
                text-align: center;
                margin-bottom: 2rem;
                font-size: 0.9rem;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            label {
                display: block;
                margin-bottom: 0.5rem;
                font-size: 0.9rem;
                color: #cbd5e1;
            }

            input {
                width: 100%;
                padding: 1rem;
                background: rgba(0, 0, 0, 0.2);
                border: 1px solid var(--glass-border);
                border-radius: 12px;
                color: white;
                font-size: 1.5rem;
                text-align: center;
                letter-spacing: 0.5rem;
                font-family: inherit;
                transition: all 0.3s;
                box-sizing: border-box;
            }

            input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.2);
            }

            .btn {
                width: 100%;
                padding: 0.8rem;
                background: var(--primary);
                color: white;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 1rem;
            }

            .btn:hover {
                background: var(--primary-hover);
                transform: translateY(-1px);
            }

            .alert {
                padding: 0.75rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
                font-size: 0.85rem;
                text-align: center;
            }

            .alert-error {
                background: rgba(239, 68, 68, 0.2);
                border: 1px solid rgba(239, 68, 68, 0.3);
                color: #fca5a5;
            }

            .alert-success {
                background: rgba(16, 185, 129, 0.2);
                border: 1px solid rgba(16, 185, 129, 0.3);
                color: #6ee7b7;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <h2>Verify OTP</h2>
            <p>A verification code has been sent to <strong>
                    <%= session.getAttribute("resetEmail") %>
                </strong>. Please enter the 6-digit code below.</p>

            <% if (request.getAttribute("error") !=null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                    <form action="${pageContext.request.contextPath}/verify-otp" method="POST">
                        <div class="form-group">
                            <input type="text" id="otp" name="otp" placeholder="••••••" maxlength="6" required
                                autofocus>
                        </div>
                        <button type="submit" class="btn">Verify OTP</button>
                    </form>

                    <div style="margin-top: 1.5rem; text-align: center; font-size: 0.85rem;">
                        <p style="margin-bottom: 0.5rem">Didn't receive the code?</p>
                        <a href="${pageContext.request.contextPath}/forgot-password"
                            style="color: var(--primary); text-decoration: none;">Resend OTP</a>
                    </div>
        </div>
    </body>

    </html>