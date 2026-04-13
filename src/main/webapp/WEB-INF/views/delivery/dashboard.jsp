<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Dashboard | CoolStock</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
    <div class="flex">

        <!-- Delivery Sidebar -->
        <div class="w-64 h-screen bg-orange-700 text-white fixed flex flex-col justify-between">
            <div>
                <div class="p-5 border-b border-orange-600 flex items-center gap-3">
                    <span class="text-2xl">🛵</span>
                    <div>
                        <h2 class="text-lg font-black">CoolStock</h2>
                        <p class="text-xs text-orange-200">Delivery Panel</p>
                    </div>
                </div>
                <nav class="mt-4 space-y-1 px-3">
                    <a href="${pageContext.request.contextPath}/delivery/dashboard"
                        class="flex items-center gap-3 py-2.5 px-4 rounded-xl font-semibold text-sm ${pageContext.request.requestURI.contains('dashboard') ? 'bg-orange-600' : 'hover:bg-orange-600 transition'}"><span>🏠</span>
                        Active Tasks</a>
                    <a href="${pageContext.request.contextPath}/delivery/history"
                        class="flex items-center gap-3 py-2.5 px-4 rounded-xl font-semibold text-sm ${pageContext.request.requestURI.contains('history') ? 'bg-orange-600' : 'hover:bg-orange-600 transition'}"><span>📜</span>
                        Order History</a>
                    <a href="${pageContext.request.contextPath}/delivery/profile"
                        class="flex items-center gap-3 py-2.5 px-4 rounded-xl font-semibold text-sm ${pageContext.request.requestURI.contains('profile') ? 'bg-orange-600' : 'hover:bg-orange-600 transition'}"><span>👤</span>
                        My Profile</a>
                </nav>
            </div>
            <div class="mb-5 px-4">
                <a href="${pageContext.request.contextPath}/logout"
                    class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm">🚪
                    Logout</a>
            </div>
        </div>

        <div class="ml-64 p-8 w-full">

            <!-- Header -->
            <div class="bg-gradient-to-r from-orange-500 to-red-500 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                <div>
                    <h1 class="text-3xl font-black">🛵 Delivery Dashboard</h1>
                    <p class="opacity-80 mt-1">Hello, ${staff.fullName}. Here are your assigned orders today.</p>
                </div>
                <div class="text-right">
                    <div id="liveDate" class="text-sm opacity-70"></div>
                    <div id="liveClock" class="text-2xl font-bold mt-1"></div>
                </div>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-3 gap-6 mb-8">
                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                    <p class="text-gray-400 text-sm">Assigned Tasks</p>
                    <p class="text-3xl font-black text-orange-500 mt-2">${countAssigned}</p>
                </div>
                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                    <p class="text-gray-400 text-sm">In Transit</p>
                    <p class="text-3xl font-black text-blue-600 mt-2">${countTransit}</p>
                </div>
                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                    <p class="text-gray-400 text-sm">Delivered Today</p>
                    <p class="text-3xl font-black text-green-600 mt-2">${countDelivered}</p>
                </div>
            </div>

            <!-- ASSIGNED ORDERS -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                <div class="p-6 border-b bg-orange-50">
                    <h2 class="text-xl font-bold text-gray-800">📋 My Logistical Tasks</h2>
                    <p class="text-gray-400 text-sm mt-0.5">Pick up and deliver assigned inventory.</p>
                </div>
                <div class="p-6 space-y-4">

                    <c:if test="${empty assignedOrders}">
                        <div class="text-center py-12 text-gray-400">
                            <div class="text-5xl mb-4">🙌</div>
                            <p class="text-lg font-bold">No orders assigned to you currently.</p>
                            <p class="text-sm">Check back later or contact your manager.</p>
                        </div>
                    </c:if>

                    <c:forEach var="o" items="${assignedOrders}">
                        <div class="border-2 rounded-2xl p-5 transition-all
                            ${o.status == 'In Transit' ? 'border-blue-200 bg-blue-50' : 
                              o.status == 'Delivered' ? 'border-green-200 bg-green-50' : 'border-gray-100 bg-white'}">
                            
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <div class="flex items-center gap-2 mb-1">
                                        <span class="font-black text-lg text-gray-800">#${o.orderNumber}</span>
                                        <span class="text-[10px] font-bold px-2 py-0.5 rounded-full uppercase
                                            ${o.status == 'In Transit' ? 'bg-blue-100 text-blue-700' : 
                                              o.status == 'Delivered' ? 'bg-green-100 text-green-700' : 'bg-orange-100 text-orange-700'}">
                                            ${o.status}
                                        </span>
                                        <c:if test="${o.deliveryPriority == 'Urgent' || o.deliveryPriority == 'Very Urgent'}">
                                            <span class="bg-red-100 text-red-600 text-[10px] font-black px-2 py-0.5 rounded-full uppercase animate-pulse">
                                                🚨 ${o.deliveryPriority}
                                            </span>
                                        </c:if>
                                    </div>
                                    <p class="text-sm text-gray-800 font-bold mt-1">🏪 ${o.customer.shopName}</p>
                                    <p class="text-xs text-gray-500 italic">📍 ${o.customer.area}, ${o.customer.city}</p>
                                    
                                    <!-- Detailed Product Table -->
                                    <div class="mt-4 overflow-hidden rounded-xl border border-gray-100 shadow-sm">
                                        <table class="w-full text-left text-xs">
                                            <thead class="bg-gray-50 text-[10px] uppercase font-black text-gray-400 tracking-widest">
                                                <tr>
                                                    <th class="px-4 py-2">Item Detail</th>
                                                    <th class="px-4 py-2 text-center">Qty</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-50 bg-white/50">
                                                <c:forEach var="item" items="${o.items}">
                                                    <tr>
                                                        <td class="px-4 py-2 font-bold text-gray-700">${item.product.name}</td>
                                                        <td class="px-4 py-2 text-center font-black text-gray-500">${item.quantity}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <p class="text-sm font-black text-indigo-600 mt-4">💰 Collect Cash: ₹${o.totalAmount}</p>
                                </div>

                                <div class="flex flex-col gap-2 min-w-[160px]">
                                    <c:choose>
                                        <c:when test="${o.status == 'Shipped' || o.status == 'Processing'}">
                                            <form action="${pageContext.request.contextPath}/delivery/updateStatus" method="post">
                                                <input type="hidden" name="orderId" value="${o.id}">
                                                <input type="hidden" name="status" value="In Transit">
                                                <button type="submit" class="w-full bg-orange-500 text-white py-3 px-4 rounded-xl font-bold text-sm hover:bg-orange-600 transition shadow-lg shadow-orange-200">
                                                    🚀 Start Delivery
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.status == 'In Transit'}">
                                            <form action="${pageContext.request.contextPath}/delivery/updateStatus" method="post" class="space-y-2">
                                                <input type="hidden" name="orderId" value="${o.id}">
                                                <input type="hidden" name="status" value="Delivered">
                                                
                                                <div class="px-3 py-2 bg-white border border-blue-200 rounded-xl">
                                                    <label class="block text-[9px] font-black text-blue-400 uppercase tracking-widest mb-1">Handover Cash To:</label>
                                                    <select name="cashierId" required class="w-full bg-transparent text-xs font-bold text-gray-700 outline-none">
                                                        <option value="">-- Choose Cashier --</option>
                                                        <c:forEach var="c" items="${cashiers}">
                                                            <option value="${c.id}">${c.fullName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <button type="submit" class="w-full bg-green-500 text-white py-3 px-4 rounded-xl font-bold text-sm hover:bg-green-600 transition shadow-lg shadow-green-200">
                                                    ✅ Mark Delivered
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="flex items-center justify-center gap-2 text-green-600 font-black text-sm py-3 bg-white rounded-xl shadow-sm border border-green-100">
                                                <span>✓</span> COMPLETED
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <a href="tel:${o.customer.phone}" class="text-center text-[10px] font-black text-blue-500 uppercase tracking-widest mt-2 hover:underline">
                                        📞 Call Customer
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- PENDING CASH TO DEPOSIT -->
            <div class="bg-white rounded-[2rem] shadow-xl overflow-hidden border-2 border-rose-100">
                <div class="p-8 border-b bg-rose-50/50 flex justify-between items-center">
                    <div>
                        <h2 class="text-2xl font-black text-rose-900 tracking-tightest">Cash Vault</h2>
                        <p class="text-rose-600/60 text-xs font-bold uppercase tracking-widest mt-1 italic">Deliveries completed, pending deposit to Cashier.</p>
                    </div>
                    <div class="px-6 py-2 bg-rose-500 text-white rounded-full text-xs font-black uppercase tracking-widest shadow-lg shadow-rose-200">
                        In Your Hand
                    </div>
                </div>
                
                <div class="p-8">
                    <c:set var="totalHandCash" value="0" />
                    <div class="space-y-3">
                        <c:forEach var="o" items="${assignedOrders}">
                            <c:if test="${o.paymentStatus == 'Pending Deposit'}">
                                <c:set var="totalHandCash" value="${totalHandCash + o.totalAmount}" />
                                <div class="flex justify-between items-center bg-white border border-rose-100 rounded-2xl p-5 shadow-sm">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-12 bg-rose-100 rounded-xl flex items-center justify-center text-xl">💵</div>
                                        <div>
                                            <p class="font-black text-gray-900 border-rose-900 tracking-tight">Order #${o.orderNumber}</p>
                                            <p class="text-xs text-gray-400 font-medium italic">Collected from ${o.customer.shopName}</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-xl font-black text-rose-600 font-mono tracking-tighter">₹${o.totalAmount}</p>
                                        <p class="text-[9px] font-black text-rose-400 uppercase tracking-widest mt-1">Ready for Cashier</p>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        
                        <c:if test="${totalHandCash == 0}">
                             <div class="text-center py-10 text-gray-300">
                                <div class="text-4xl mb-3 opacity-30">💼</div>
                                <p class="text-sm font-bold italic">No pending cash. Keep delivering!</p>
                             </div>
                        </c:if>
                    </div>

                    <c:if test="${totalHandCash > 0}">
                        <div class="mt-8 pt-8 border-t border-rose-50 flex justify-between items-center px-4">
                            <div>
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Total Vault Collection</p>
                                <p class="text-4xl font-black text-rose-600 font-mono tracking-tighter">₹${totalHandCash}</p>
                            </div>
                            <div class="bg-gray-900 text-white px-8 py-5 rounded-3xl text-sm font-black uppercase tracking-widest shadow-xl">
                                Give to Cashier
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>
    </div>

    <script>
        setInterval(() => {
            const now = new Date();
            document.getElementById('liveClock').innerText = now.toLocaleTimeString();
            document.getElementById('liveDate').innerText = now.toDateString();
        }, 1000);
    </script>
</body>
</html>