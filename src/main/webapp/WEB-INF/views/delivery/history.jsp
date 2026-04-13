<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History | CoolStock</title>
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
                        <h2 class="text-lg font-black text-white">CoolStock</h2>
                        <p class="text-xs text-orange-200 uppercase font-black">History Vault</p>
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
                    class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm text-white">🚪
                    Logout</a>
            </div>
        </div>

        <div class="ml-64 p-8 w-full">

            <!-- Header -->
            <div class="bg-gradient-to-r from-gray-700 to-gray-900 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                <div>
                    <h1 class="text-3xl font-black text-white">📜 Delivery History</h1>
                    <p class="opacity-80 mt-1">Complete record of your past logistical completions and handovers.</p>
                </div>
                <div class="text-right">
                    <p class="text-sm opacity-50 font-bold uppercase tracking-widest">Global Record</p>
                </div>
            </div>

            <!-- HISTORY LIST -->
            <div class="bg-white rounded-[2rem] shadow-xl overflow-hidden border border-gray-100 pb-10">
                <div class="p-8 border-b bg-gray-50 flex justify-between items-center">
                    <div>
                        <h2 class="text-xl font-black text-gray-800">Historical Archive</h2>
                        <p class="text-gray-400 text-xs font-bold mt-1 uppercase tracking-widest">Search and track past shipments.</p>
                    </div>
                </div>
                
                <div class="overflow-x-auto px-4">
                    <table class="w-full text-left text-sm mt-6">
                        <thead class="bg-gray-50 text-[10px] uppercase font-black text-gray-400 tracking-widest">
                            <tr>
                                <th class="py-4 px-6 rounded-l-2xl">Order #</th>
                                <th class="px-6">Customer Shop</th>
                                <th class="px-6 text-center">Date</th>
                                <th class="px-6">Amount</th>
                                <th class="px-6 text-center">Status</th>
                                <th class="px-6 rounded-r-2xl">Verification</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50">
                            <c:if test="${empty historyOrders}">
                                <tr>
                                    <td colspan="6" class="text-center py-20 text-gray-300 italic font-bold">No historical data found.</td>
                                </tr>
                            </c:if>
                            <c:forEach var="h" items="${historyOrders}">
                                <tr class="hover:bg-gray-50/50 transition">
                                    <td class="py-6 px-6 font-black text-gray-900">#${h.orderNumber}</td>
                                    <td class="px-6 font-bold text-gray-600">${h.customer.shopName}</td>
                                    <td class="px-6 text-center text-xs text-gray-400 font-bold">
                                        <fmt:formatDate value="${h.orderDate}" pattern="dd MMM yyyy" />
                                    </td>
                                    <td class="px-6 font-black text-indigo-600">₹${h.totalAmount}</td>
                                    <td class="px-6 text-center">
                                        <span class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-tightest
                                            ${h.status == 'Delivered' ? 'bg-teal-100 text-teal-700' : 'bg-gray-100 text-gray-500'}">
                                            ${h.status}
                                        </span>
                                    </td>
                                    <td class="px-6">
                                        <span class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-tightest
                                            ${h.paymentStatus == 'Paid' ? 'bg-emerald-100 text-emerald-700' : 
                                              h.paymentStatus == 'Pending Deposit' ? 'bg-orange-100 text-orange-700' : 'bg-rose-100 text-rose-700'}">
                                            ${h.paymentStatus}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
