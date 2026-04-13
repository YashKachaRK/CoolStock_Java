<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Track Orders | CoolStock</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">

    <!-- Customer Nav -->
    <nav class="bg-white shadow-sm sticky top-0 z-40 px-6 py-3 flex justify-between items-center">
        <div class="flex items-center gap-2">
            <span class="text-3xl">🍦</span>
            <div>
                <span class="text-xl font-black text-gray-800">CoolStock</span>
                <span class="text-xs text-gray-400 ml-2 uppercase tracking-widest font-bold">Customer Portal</span>
            </div>
        </div>
        <div class="flex gap-6 text-sm font-bold uppercase tracking-wider">
            <a href="orders" class="text-gray-400 hover:text-purple-600 transition">📦 Place Order</a>
            <a href="track" class="text-purple-600 border-b-2 border-purple-600 pb-1">📍 Track Orders</a>
            <a href="profile" class="text-gray-400 hover:text-purple-600 transition">👤 My Profile</a>
        </div>
        <a href="${pageContext.request.contextPath}/logout"
            class="bg-red-50 text-red-600 px-5 py-2.5 rounded-2xl font-black text-xs hover:bg-red-100 transition uppercase tracking-widest border border-red-100">
            🚪 Logout
        </a>
    </nav>

    <div class="max-w-4xl mx-auto px-6 py-8">

        <div class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-10 rounded-[2.5rem] mb-10 shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -mr-32 -mt-32 blur-3xl"></div>
            <h1 class="text-4xl font-black tracking-tighter">📍 Order Journey</h1>
            <p class="opacity-90 mt-2 font-medium italic">Monitor your bulk inventory shipments in real-time.</p>
        </div>

        <!-- Orders Container -->
        <div id="ordersContainer" class="space-y-8">
            <c:if test="${empty ordersList}">
                <div class="text-center py-20 bg-white rounded-[2rem] shadow-xl border border-gray-100">
                    <div class="text-8xl mb-6">📦</div>
                    <h2 class="text-2xl font-black text-gray-800 mb-2 tracking-tight">No Active Orders</h2>
                    <p class="text-gray-400 mb-8 max-w-xs mx-auto">You haven't placed any bulk orders yet. Let's restock your shop!</p>
                    <a href="orders"
                        class="px-10 py-4 bg-purple-600 text-white font-black rounded-2xl hover:bg-purple-700 transition shadow-xl shadow-purple-200">
                        PLACE FIRST ORDER
                    </a>
                </div>
            </c:if>

            <c:forEach var="order" items="${ordersList}">
                <div class="bg-white rounded-[2rem] shadow-xl p-8 border border-gray-100 relative overflow-hidden group hover:border-purple-200 transition-colors">
                    <div class="flex justify-between items-start mb-6">
                        <div>
                            <div class="flex items-center gap-3">
                                <span class="font-black text-2xl text-gray-900 tracking-tighter">${order.orderNumber}</span>
                                <span class="px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest 
                                    ${order.status == 'Processing' ? 'bg-orange-100 text-orange-600' : 
                                      order.status == 'Shipped' ? 'bg-blue-100 text-blue-600' : 
                                      order.status == 'Delivered' ? 'bg-teal-100 text-teal-600' : 
                                      order.status == 'Cancelled' ? 'bg-red-100 text-red-600' : 'bg-green-100 text-green-600'}">
                                    ${order.status}
                                </span>
                                <c:if test="${order.deliveryPriority != 'Regular'}">
                                    <span class="px-3 py-1.5 bg-purple-600 text-white rounded-full text-[10px] font-black uppercase tracking-widest shadow-lg shadow-purple-200 animate-pulse">
                                        ⚡ ${order.deliveryPriority}
                                    </span>
                                </c:if>
                            </div>
                            <p class="text-gray-400 text-xs mt-2 font-bold uppercase tracking-widest">
                                📅 <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" />
                            </p>
                        </div>
                        <div class="text-right">
                            <p class="font-black text-3xl text-gray-900 font-mono tracking-tighter">₹${order.totalAmount}</p>
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mt-1">Pending COD</p>
                        </div>
                    </div>

                    <div class="bg-gray-50 rounded-2xl p-5 mb-8 border border-gray-100">
                        <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-2">Order Contents</p>
                        <p class="text-sm font-bold text-gray-700 leading-relaxed">${order.itemsSummary}</p>
                    </div>

                    <!-- Progress Bar -->
                    <div class="relative px-4 mb-8">
                        <div class="flex justify-between items-center relative z-10 text-[10px] font-black uppercase tracking-widest">
                            <div class="flex flex-col items-center">
                                <div class="w-10 h-10 rounded-2xl bg-purple-600 text-white flex items-center justify-center shadow-lg shadow-purple-100 mb-2">✓</div>
                                <span class="text-purple-700">Placed</span>
                            </div>
                            <c:set var="isShipped" value="${order.status == 'Shipped' || order.status == 'Delivered'}" />
                            <div class="flex flex-col items-center">
                                <div class="w-10 h-10 rounded-2xl ${isShipped ? 'bg-purple-600 text-white shadow-lg shadow-purple-100' : 'bg-gray-100 text-gray-300'} flex items-center justify-center mb-2">
                                    ${isShipped ? '✓' : '2'}
                                </div>
                                <span class="${isShipped ? 'text-purple-700' : 'text-gray-300'}">Shipped</span>
                            </div>
                            <c:set var="isDelivered" value="${order.status == 'Delivered'}" />
                            <div class="flex flex-col items-center">
                                <div class="w-10 h-10 rounded-2xl ${isDelivered ? 'bg-purple-600 text-white shadow-lg shadow-purple-100' : 'bg-gray-100 text-gray-300'} flex items-center justify-center mb-2">
                                    ${isDelivered ? '✓' : '3'}
                                </div>
                                <span class="${isDelivered ? 'text-purple-700' : 'text-gray-300'}">Delivered</span>
                            </div>
                        </div>
                        <div class="absolute top-5 left-12 right-12 h-1 bg-gray-100 -z-0">
                            <div class="h-full bg-purple-600 transition-all duration-1000" 
                                 style="width: ${order.status == 'Processing' ? '0%' : order.status == 'Shipped' ? '50%' : order.status == 'Delivered' ? '100%' : '0%'}">
                            </div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${order.status == 'Delivered'}">
                            <div class="flex gap-4">
                                <button onclick="alert('Downloading professional invoice...')" 
                                        class="flex-1 py-4 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition shadow-xl shadow-emerald-100 text-xs tracking-widest">
                                    📄 DOWNLOAD TAX INVOICE
                                </button>
                                <button class="px-8 py-4 bg-gray-100 text-gray-700 font-black rounded-2xl hover:bg-gray-200 transition text-xs tracking-widest">
                                    SUPPORT
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="bg-purple-50 rounded-2xl py-4 px-6 flex items-center gap-4 border border-purple-100">
                                <span class="animate-pulse">🛵</span>
                                <p class="text-xs font-bold text-purple-700">Order is currently being ${order.status.toLowerCase()}. We'll notify you when it moves!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>

        <div class="mt-12 text-center text-gray-400 text-xs font-bold uppercase tracking-[0.3em]">
            Powered by CoolStock Enterprise Logistics
        </div>
    </div>

</body>
</html>