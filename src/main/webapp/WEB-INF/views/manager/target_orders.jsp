<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logistics Manager | CoolStock</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f8fafc; }
        .glass-card { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(10px); }
    </style>
</head>
<body class="min-h-screen font-light">
    <div class="flex">
        <%@ include file="sidebar.jsp" %>
        
        <main class="ml-64 p-8 w-full max-w-[1600px] mx-auto">
            <!-- Header Section -->
            <div class="bg-gradient-to-br from-indigo-900 via-blue-800 to-cyan-600 rounded-[2.5rem] p-10 mb-8 shadow-2xl relative overflow-hidden text-white border border-white/10">
                <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-white/5 rounded-full -mr-64 -mt-64 blur-[100px]"></div>
                <div class="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                    <div>
                        <div class="flex items-center gap-3 mb-2">
                            <span class="bg-white/20 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest border border-white/20">Operations Hub</span>
                        </div>
                        <h1 class="text-5xl font-black tracking-tightest leading-tight">Order <span class="text-cyan-300">Intelligence</span></h1>
                        <p class="text-blue-100/70 font-medium text-lg mt-1 italic">Simplified logistical tracking and inventory audit logs.</p>
                    </div>
                </div>
            </div>

            <!-- Toolbar / Filters -->
            <div class="glass-card bg-white p-6 rounded-[2rem] shadow-xl border border-gray-100 mb-8 flex flex-wrap gap-4 items-center">
                <div class="relative flex-grow min-w-[300px]">
                    <span class="absolute left-5 top-1/2 -translate-y-1/2 text-gray-400 uppercase text-[10px] font-black italic">Search ID:</span>
                    <input type="text" id="searchInput" oninput="filterOrders()" placeholder="e.g. ORD-1025" 
                           class="w-full pl-24 pr-6 py-4 bg-gray-50 border-none rounded-2xl text-sm font-bold text-gray-800 focus:ring-2 focus:ring-blue-500/20 transition-all outline-none">
                </div>

                <div class="flex items-center gap-3">
                    <div class="flex items-center bg-gray-50 rounded-2xl px-4 py-2 border border-gray-100">
                        <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest mr-3">Date Range:</span>
                        <input type="date" id="fromDate" onchange="filterOrders()" class="bg-transparent text-xs font-bold outline-none text-gray-700">
                        <span class="mx-2 text-gray-300">→</span>
                        <input type="date" id="toDate" onchange="filterOrders()" class="bg-transparent text-xs font-bold outline-none text-gray-700">
                    </div>

                    <select id="statusFilter" onchange="filterOrders()" 
                            class="bg-gray-50 border border-gray-100 px-6 py-4 rounded-2xl text-[10px] font-black text-gray-600 outline-none hover:bg-white transition cursor-pointer uppercase tracking-widest">
                        <option value="all">All Lifecycles</option>
                        <option value="Processing">Processing</option>
                        <option value="Shipped">Shipped</option>
                        <option value="Delivered">Delivered</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>

                    <button onclick="clearFilters()" class="px-6 py-4 bg-gray-900 text-white rounded-2xl text-[10px] font-black hover:bg-black transition-all uppercase tracking-widest">
                        Clear Audit
                    </button>
                </div>
            </div>

            <!-- Main Log Table -->
            <div class="bg-white rounded-[2.5rem] shadow-2xl border border-gray-100 overflow-hidden relative">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-gray-50/50 text-[10px] uppercase font-black text-gray-400 tracking-[0.2em]">
                            <tr>
                                <th class="px-8 py-6">Order Identity & Items</th>
                                <th class="px-8 py-6">Shop context</th>
                                <th class="px-8 py-6">Financials</th>
                                <th class="px-8 py-6">Logistics Lead</th>
                                <th class="px-8 py-6 text-right">Audit</th>
                            </tr>
                        </thead>
                        <tbody id="orderTableBody" class="divide-y divide-gray-50">
                            <c:forEach var="o" items="${ordersList}">
                                <tr class="order-row transition-all hover:bg-blue-50/30 group" 
                                    data-id="${o.orderNumber.toLowerCase()}" 
                                    data-status="${o.status}"
                                    data-date="<fmt:formatDate value='${o.orderDate}' pattern='yyyy-MM-dd' />">
                                    <td class="px-8 py-6">
                                        <div class="flex items-start gap-4">
                                            <div class="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center text-blue-700 font-black text-xs shrink-0">
                                                ${o.deliveryPriority == 'Very Urgent' ? '!!' : (o.deliveryPriority == 'Urgent' ? '!' : '#')}
                                            </div>
                                            <div>
                                                <p class="font-black text-gray-900 text-lg tracking-tight">${o.orderNumber}</p>
                                                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2 font-mono">
                                                    📅 <fmt:formatDate value="${o.orderDate}" pattern="dd MMM, HH:mm" />
                                                </p>
                                                <!-- Simple Item Summary -->
                                                <div class="bg-blue-50/50 p-3 rounded-xl border border-blue-100/50 max-w-sm">
                                                    <p class="text-[10px] font-black text-blue-800 uppercase tracking-widest mb-1 italic">🛒 Items Bought:</p>
                                                    <p class="text-[11px] text-blue-600 font-bold leading-relaxed line-clamp-2">${o.itemsSummary}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <p class="font-bold text-gray-800 text-sm tracking-tight">${o.customer.shopName}</p>
                                        <p class="text-[10px] text-gray-400 mt-1 font-medium italic">📍 ${o.customer.city}</p>
                                    </td>
                                    <td class="px-8 py-6">
                                        <p class="font-black text-blue-700 text-xl font-mono tracking-tighter">₹${o.totalAmount}</p>
                                        <span class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest border mt-2 inline-block
                                            ${o.status == 'Processing' ? 'bg-orange-50 text-orange-600 border-orange-100' : 
                                              o.status == 'Shipped' ? 'bg-blue-50 text-blue-600 border-blue-100' : 
                                              o.status == 'Delivered' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' : 
                                              'bg-rose-50 text-rose-600 border-rose-100'}">
                                            ${o.status}
                                        </span>
                                    </td>
                                    <td class="px-8 py-6">
                                        <c:choose>
                                            <c:when test="${not empty o.deliveryBoy}">
                                                <div class="flex items-center gap-3">
                                                    <div class="w-8 h-8 rounded-full bg-indigo-100 flex center justify-center text-indigo-700 text-[10px] font-black p-2">
                                                        ${o.deliveryBoy.fullName.substring(0,1)}
                                                    </div>
                                                    <div>
                                                        <p class="text-xs font-black text-gray-800 uppercase tracking-tighter">${o.deliveryBoy.fullName}</p>
                                                        <p class="text-[9px] text-indigo-500 font-bold uppercase tracking-widest mt-0.5 animate-pulse">Lead Assigned</p>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/manager/assignOrder" method="post" class="flex gap-2">
                                                    <input type="hidden" name="orderId" value="${o.id}">
                                                    <select name="staffId" class="bg-gray-100 border-none rounded-xl px-3 py-2 text-[10px] font-black text-gray-600 outline-none focus:ring-2 focus:ring-blue-500/20">
                                                        <option value="">SELECT LEAD...</option>
                                                        <c:forEach var="boy" items="${deliveryBoys}">
                                                            <option value="${boy.id}">${boy.fullName}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <button type="submit" class="bg-blue-600 text-white p-2 rounded-xl text-[10px] font-black hover:bg-blue-700 transition active:scale-90">GO</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-8 py-6 text-right">
                                        <form action="${pageContext.request.contextPath}/manager/orders/delete" method="POST" onsubmit="return confirm('Archive this transaction forever?')">
                                            <input type="hidden" name="id" value="${o.id}">
                                            <button type="submit" class="w-10 h-10 bg-white border border-gray-100 rounded-xl shadow-lg hover:border-rose-200 text-sm transition active:scale-90" title="Delete Log">🗑️</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script>
        function filterOrders() {
            const q = document.getElementById('searchInput').value.toLowerCase();
            const status = document.getElementById('statusFilter').value;
            const from = document.getElementById('fromDate').value;
            const to = document.getElementById('toDate').value;
            const rows = document.querySelectorAll('.order-row');

            rows.forEach(row => {
                const id = row.getAttribute('data-id');
                const rowStatus = row.getAttribute('data-status');
                const rowDate = row.getAttribute('data-date');
                
                const matchId = id.includes(q);
                const matchStatus = status === 'all' || rowStatus === status;
                
                let matchDate = true;
                if (from && rowDate < from) matchDate = false;
                if (to && rowDate > to) matchDate = false;

                row.style.display = (matchId && matchStatus && matchDate) ? '' : 'none';
            });
        }

        function clearFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = 'all';
            document.getElementById('fromDate').value = '';
            document.getElementById('toDate').value = '';
            filterOrders();
        }
    </script>
</body>
</html>