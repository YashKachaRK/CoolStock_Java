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
            <div class="flex justify-between items-center relative z-10">
                <div>
                    <h1 class="text-4xl font-black tracking-tighter text-white">📍 Order Journey</h1>
                    <p class="opacity-90 mt-2 font-medium italic">Monitor your bulk inventory shipments in real-time.</p>
                </div>
                <div class="bg-white/20 p-4 rounded-3xl border border-white/30">
                    <p class="text-[10px] font-black uppercase tracking-widest mb-2 opacity-70">Quick Filter</p>
                    <input type="date" id="dateFilter" onchange="filterOrders()" class="bg-transparent text-white font-bold outline-none cursor-pointer">
                </div>
            </div>
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
                <div class="order-card bg-white rounded-[2rem] shadow-xl p-8 border border-gray-100 relative overflow-hidden group hover:border-purple-200 transition-colors" 
                     data-date="<fmt:formatDate value='${order.orderDate}' pattern='yyyy-MM-dd' />">
                    
                    <div class="flex justify-between items-start mb-6">
                        <div>
                            <div class="flex items-center gap-3">
                                <span class="font-black text-2xl text-gray-900 tracking-tighter">${order.orderNumber}</span>
                                <span class="px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest 
                                    ${order.status == 'Processing' ? 'bg-orange-100 text-orange-600' : 
                                      order.status == 'Shipped' || order.status == 'In Transit' ? 'bg-blue-100 text-blue-600' : 
                                      order.status == 'Delivered' ? 'bg-teal-100 text-teal-600' : 
                                      order.status == 'Cancelled' ? 'bg-red-100 text-red-600' : 'bg-green-100 text-green-600'}">
                                    ${order.status}
                                </span>
                            </div>
                            <p class="text-gray-400 text-xs mt-2 font-bold uppercase tracking-widest">
                                📅 <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" />
                            </p>
                        </div>
                        <div class="text-right">
                            <p class="font-black text-3xl text-gray-900 font-mono tracking-tighter">₹${order.totalAmount}</p>
                            <span class="px-2 py-0.5 rounded bg-gray-100 text-[9px] font-black text-gray-400 uppercase tracking-widest">${order.paymentStatus}</span>
                        </div>
                    </div>

                    <div class="bg-gray-50 rounded-2xl p-5 mb-8 border border-gray-100">
                        <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-2">Order Contents</p>
                        <p class="text-sm font-bold text-gray-700 leading-relaxed">${order.itemsSummary}</p>
                    </div>

                    <!-- Delivery Boy Info (SHIPPED STAGE) -->
                    <c:if test="${(order.status == 'Shipped' || order.status == 'In Transit' || order.status == 'Delivered') && not empty order.deliveryBoy}">
                        <div class="bg-blue-50 rounded-2xl p-5 mb-8 border border-blue-100 flex items-center justify-between">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 rounded-xl bg-blue-600 flex items-center justify-center text-xl">🛵</div>
                                <div>
                                    <p class="text-[10px] font-black text-blue-400 uppercase tracking-widest mb-1">Assigned Delivery Staff</p>
                                    <p class="text-sm font-black text-blue-900 uppercase">${order.deliveryBoy.fullName}</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <a href="tel:${order.deliveryBoy.phone}" class="bg-blue-600 text-white px-4 py-2 rounded-xl text-xs font-black shadow-lg shadow-blue-100 hover:bg-blue-700 transition">
                                    📞 CALL STAFF
                                </a>
                                <p class="text-[10px] font-bold text-blue-400 mt-1">${order.deliveryBoy.phone}</p>
                            </div>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${order.status == 'Cancelled'}">
                            <div class="bg-red-50 rounded-2xl py-6 px-10 text-center border border-red-100">
                                <p class="text-red-700 font-black text-sm uppercase italic">This order has been cancelled and amounts refunded.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Progress Bar -->
                            <div class="relative px-4 mb-8 mt-10">
                                <div class="flex justify-between items-center relative z-10 text-[10px] font-black uppercase tracking-widest">
                                    <div class="flex flex-col items-center">
                                        <div class="w-10 h-10 rounded-2xl bg-purple-600 text-white flex items-center justify-center shadow-lg shadow-purple-100 mb-2">✓</div>
                                        <span class="text-purple-700">Placed</span>
                                    </div>
                                    <c:set var="isShipped" value="${order.status == 'Shipped' || order.status == 'In Transit' || order.status == 'Delivered'}" />
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
                                         style="width: ${order.status == 'Processing' ? '0%' : (order.status == 'Shipped' || order.status == 'In Transit') ? '50%' : order.status == 'Delivered' ? '100%' : '0%'}">
                                    </div>
                                </div>
                            </div>

                            <div class="flex gap-4">
                                <c:choose>
                                    <c:when test="${order.status == 'Delivered'}">
                                        <a href="${pageContext.request.contextPath}/invoice/print?orderId=${order.id}" target="_blank"
                                                class="flex-1 py-4 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition shadow-xl shadow-emerald-100 text-xs tracking-widest text-center flex items-center justify-center">
                                            📄 DOWNLOAD TAX INVOICE
                                        </a>
                                    </c:when>
                                    <c:when test="${order.status == 'Processing'}">
                                        <form action="${pageContext.request.contextPath}/customer/cancelOrder" method="post" class="flex-1">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <button type="submit" class="w-full py-4 bg-red-50 text-red-600 font-black rounded-2xl hover:bg-red-600 hover:text-white transition text-xs tracking-widest border border-red-100">
                                                🚫 CANCEL ORDER
                                            </button>
                                        </form>
                                    </c:when>
                                </c:choose>
                                <button class="flex-1 px-8 py-4 bg-gray-100 text-gray-700 font-black rounded-2xl hover:bg-gray-200 transition text-xs tracking-widest">
                                    HELP CENTER
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>

        <script>
            function filterOrders() {
                const date = document.getElementById('dateFilter').value;
                const cards = document.querySelectorAll('.order-card');
                cards.forEach(card => {
                    if (!date || card.dataset.date === date) {
                        card.classList.remove('hidden');
                    } else {
                        card.classList.add('hidden');
                    }
                });
            }

            // Shared Invoice Logic (can be reused across panels)
            function previewInvoice(orderId, customer, city, items, amount) {
                // In a real app, this would redirect to a PDF generator
                alert("Generating Professional Tax Invoice for " + orderId + "...\nCustomer: " + customer + "\nAmount: \u20B9" + amount);
            }
        </script>

        <div class="mt-12 text-center text-gray-400 text-xs font-bold uppercase tracking-[0.3em]">
            Powered by CoolStock Enterprise Logistics
        </div>
    </div>

</body>
</html>