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
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-fade-in { animation: fadeIn 0.4s ease-out forwards; }
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
                            <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                        </div>
                        <h1 class="text-5xl font-black tracking-tightest leading-tight">Order <span class="text-cyan-300">Intelligence</span></h1>
                        <p class="text-blue-100/70 font-medium text-lg mt-1 italic">End-to-end logistics tracking and inventory audit logs.</p>
                    </div>
                    
                    <!-- Quick Stats Cards (Inset) -->
                    <div class="flex gap-4">
                        <div class="glass-card bg-white/10 backdrop-blur-xl border border-white/20 p-5 rounded-3xl min-w-[140px] text-center">
                            <p class="text-white/60 text-[10px] font-bold uppercase tracking-widest mb-1">Unassigned</p>
                            <p class="text-3xl font-black text-white font-mono tracking-tighter">${countProcessing}</p>
                        </div>
                        <div class="glass-card bg-white/10 backdrop-blur-xl border border-white/20 p-5 rounded-3xl min-w-[140px] text-center">
                            <p class="text-white/60 text-[10px] font-bold uppercase tracking-widest mb-1">Critical</p>
                            <p class="text-3xl font-black text-rose-400 font-mono tracking-tighter">${countUrgent}</p>
                        </div>
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
                            class="bg-gray-50 border border-gray-100 px-6 py-4 rounded-2xl text-xs font-black text-gray-600 outline-none hover:bg-white transition cursor-pointer uppercase tracking-widest">
                        <option value="all">All Lifecycles</option>
                        <option value="Processing">Processing</option>
                        <option value="Shipped">Shipped</option>
                        <option value="Delivered">Delivered</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>

                    <button onclick="clearFilters()" class="px-6 py-4 bg-gray-900 text-white rounded-2xl text-[10px] font-black hover:bg-black transition-all shadow-lg hover:shadow-gray-200 active:scale-95 uppercase tracking-widest">
                        Clear Audit
                    </button>
                </div>
            </div>

            <!-- Main Log Table -->
            <div class="bg-white rounded-[2.5rem] shadow-2xl border border-gray-100 overflow-hidden relative">
                <div class="p-8 border-b border-gray-50 flex justify-between items-center bg-gray-50/50">
                    <div>
                        <h2 class="text-2xl font-black text-gray-900 tracking-tightest">Transactional DNA</h2>
                        <p class="text-gray-400 text-xs font-medium italic">Viewing total records across the logistic horizon.</p>
                    </div>
                    <div class="flex items-center gap-2">
                        <div class="w-3 h-3 rounded-full bg-blue-500 animate-pulse"></div>
                        <span class="text-[10px] font-black text-blue-600 uppercase tracking-[0.2em] italic">Real-Time Ledger</span>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-gray-50/50 text-[10px] uppercase font-black text-gray-400 tracking-[0.2em]">
                            <tr>
                                <th class="px-8 py-6">Identity</th>
                                <th class="px-8 py-6">Shop context</th>
                                <th class="px-8 py-6">Financials</th>
                                <th class="px-8 py-6">Logistic Lead</th>
                                <th class="px-8 py-6">Lifecycle Stage</th>
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
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center text-blue-700 font-black text-xs">
                                                ${o.deliveryPriority == 'Very Urgent' ? '!!' : (o.deliveryPriority == 'Urgent' ? '!' : 'OK')}
                                            </div>
                                            <div>
                                                <p class="font-black text-gray-900 text-lg tracking-tight">${o.orderNumber}</p>
                                                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-1">
                                                    📅 <fmt:formatDate value="${o.orderDate}" pattern="dd MMM, HH:mm" />
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <p class="font-bold text-gray-800 text-sm tracking-tight">${o.customer.shopName}</p>
                                        <p class="text-[10px] text-gray-400 mt-0.5 font-medium italic">📍 ${o.customer.city}</p>
                                    </td>
                                    <td class="px-8 py-6">
                                        <p class="font-black text-blue-700 text-xl font-mono tracking-tighter">₹${o.totalAmount}</p>
                                        <p class="text-[9px] text-gray-400 font-black uppercase tracking-widest mt-1">COD Ledger</p>
                                    </td>
                                    <td class="px-8 py-6">
                                        <c:choose>
                                            <c:when test="${not empty o.deliveryBoy}">
                                                <div class="flex items-center gap-3">
                                                    <div class="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 text-[10px] font-black">
                                                        ${o.deliveryBoy.fullName.substring(0,1)}
                                                    </div>
                                                    <div>
                                                        <p class="text-xs font-black text-gray-800 uppercase tracking-tighter">${o.deliveryBoy.fullName}</p>
                                                        <p class="text-[9px] text-indigo-500 font-bold uppercase tracking-widest">Assigned Lead</p>
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
                                    <td class="px-8 py-6">
                                        <span class="px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest border
                                            ${o.status == 'Processing' ? 'bg-orange-50 text-orange-600 border-orange-100' : 
                                              o.status == 'Shipped' ? 'bg-blue-50 text-blue-600 border-blue-100' : 
                                              o.status == 'Delivered' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' : 
                                              'bg-rose-50 text-rose-600 border-rose-100'}">
                                            ${o.status}
                                        </span>
                                    </td>
                                    <td class="px-8 py-6 text-right">
                                        <div class="flex justify-end gap-2">
                                            <button onclick="viewOrderItems(${o.id}, '${o.orderNumber}')" 
                                                    class="w-10 h-10 bg-white border border-gray-100 rounded-xl shadow-lg hover:border-blue-200 text-sm transition active:scale-90" title="View Audit">📦</button>
                                            <form action="${pageContext.request.contextPath}/manager/orders/delete" method="POST" onsubmit="return confirm('Archive this transaction forever?')">
                                                <input type="hidden" name="id" value="${o.id}">
                                                <button type="submit" class="w-10 h-10 bg-white border border-gray-100 rounded-xl shadow-lg hover:border-rose-200 text-sm transition active:scale-90" title="Delete Log">🗑️</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Items Modal -->
    <div id="itemsModal" class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[100] hidden flex items-center justify-center p-4">
        <div class="bg-white w-full max-w-2xl rounded-[3rem] shadow-2xl overflow-hidden animate-fade-in">
            <div class="p-8 bg-gradient-to-r from-blue-700 to-indigo-800 text-white flex justify-between items-center">
                <div>
                    <h3 class="text-3xl font-black tracking-tightest">Order <span id="modalOrderNumber" class="text-blue-200"></span></h3>
                    <p class="text-blue-100/60 text-[10px] font-bold uppercase tracking-widest mt-1 tracking-tighter">Itemized Transaction Detail</p>
                </div>
                <button onclick="closeModal()" class="w-12 h-12 rounded-2xl bg-white/10 flex items-center justify-center text-white hover:bg-white/20 transition-all font-black">&times;</button>
            </div>
            
            <div class="p-8 max-h-[60vh] overflow-y-auto custom-scrollbar">
                <table class="w-full text-left">
                    <thead class="text-[10px] font-black text-gray-400 uppercase tracking-widest border-b border-gray-100 pb-4">
                        <tr>
                            <th class="py-4">SKU Product</th>
                            <th class="py-4 text-center">Qty</th>
                            <th class="py-4 text-right">Unit Price</th>
                            <th class="py-4 text-right">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody id="itemsList" class="divide-y divide-gray-50">
                        <!-- Items injected here -->
                    </tbody>
                </table>
            </div>

            <div class="p-8 bg-gray-50 border-t border-gray-100 flex justify-end">
                <button onclick="closeModal()" class="px-8 py-4 bg-gray-100 text-gray-900 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-gray-200 transition active:scale-95">
                    Close Audit
                </button>
            </div>
        </div>
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

        async function viewOrderItems(orderId, orderNum) {
            const modal = document.getElementById('itemsModal');
            const list = document.getElementById('itemsList');
            const label = document.getElementById('modalOrderNumber');
            
            label.innerText = orderNum;
            list.innerHTML = `<tr><td colspan="4" class="py-10 text-center text-gray-400 text-[10px] font-black uppercase animate-pulse">Analyzing Ledger...</td></tr>`;
            modal.classList.remove('hidden');

            try {
                const response = await fetch(`${pageContext.request.contextPath}/manager/orders/items?id=` + orderId);
                if (!response.ok) throw new Error("Server Error");
                const items = await response.json();
                
                if (!items || items.length === 0) {
                    list.innerHTML = `<tr><td colspan="4" class="py-10 text-center text-gray-400 text-xs font-black uppercase tracking-widest">No distinct items found for this record.</td></tr>`;
                    return;
                }

                list.innerHTML = items.map(item => {
                    const productName = (item.product && item.product.name) ? item.product.name : "Archived SKU";
                    return `
                        <tr class="hover:bg-gray-50/50 transition border-b border-gray-50">
                             <td class="py-5">
                                <p class="font-bold text-gray-800 text-sm whitespace-nowrap overflow-hidden text-ellipsis max-w-[250px]">${productName}</p>
                             </td>
                             <td class="py-5 text-center font-black text-gray-500 text-sm">${item.quantity}</td>
                             <td class="py-5 text-right font-bold text-gray-400 text-xs tracking-tighter">₹${item.unitPrice}</td>
                             <td class="py-5 text-right font-black text-blue-700 text-sm tracking-tighter">₹${item.totalPrice}</td>
                        </tr>
                    `;
                }).join('');
                
            } catch (err) {
                list.innerHTML = `<tr><td colspan="4" class="py-10 text-center text-rose-500 text-[10px] font-black uppercase">⚠️ Audit Failed to Load</td></tr>`;
            }
        }

        function closeModal() {
            document.getElementById('itemsModal').classList.add('hidden');
        }
    </script>
</body>
</html>