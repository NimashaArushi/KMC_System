<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="KMC_Client.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>KMC Event Management System</title>
    
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet" />
    
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            height: 100vh;
            width: 100vw;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Inter', sans-serif;
            background-color: #090d16;
        }

       
        .bg-video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }

       
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.65);
            z-index: 2;
        }

      
        .loader-card {
            position: relative;
            z-index: 3;
            text-align: center;
            padding: 50px 40px;
            width: 90%;
            max-width: 520px;
            background: rgba(255, 255, 255, 0.07);
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .subtitle {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 4px;
            color: #c084fc; 
            font-weight: 600;
            margin-bottom: 8px;
        }

        h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: 1px;
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .status-text {
            font-size: 0.95rem;
            color: #cbd5e1;
            font-weight: 300;
            margin-bottom: 30px;
        }

      
        .spinner-container {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .spinner {
            width: 48px;
            height: 48px;
            border: 4px solid rgba(255, 255, 255, 0.1);
            border-left-color: #a855f7; 
            border-radius: 50%;
            animation: spin 0.9s cubic-bezier(0.55, 0.15, 0.45, 0.85) infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>

    <script type="text/javascript">
        setTimeout(function () {
            window.location.href = "Participants.aspx";
        }, 5000);
    </script>
</head>
<body>

    <video class="bg-video" autoplay muted loop playsinline>
        <source src="bg-video.mp4.mp4" type="video/mp4" />
    </video>

    <div class="overlay"></div>


    <form id="form1" runat="server" style="z-index: 3;">
        <div class="loader-card">
            <div class="subtitle">✨ WELCOME TO ✨</div>
            <h1>KMC Event Management System</h1>
            <p class="status-text">Loading system resources, please wait...</p>
            <div class="spinner-container">
                <div class="spinner"></div>
            </div>
        </div>
    </form>

</body>
</html>