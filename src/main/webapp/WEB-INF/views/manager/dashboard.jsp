<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard | CoolStock</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">
    <div class="flex">

        <%@ include file="sidebar.jsp" %>

        <div class="ml-64 p-8 w-full">

            <!-- Header -->
            <div class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-8 rounded-3xl mb-8 flex justify-between items-center shadow-xl">
                <div>
                    <h1 class="text-4xl font-black tracking-tight">📊 Manager Dashboard</h1>
                    <p class="opacity-80 mt-1 font-medium italic">Operational Control Center & Logistics Command</p>
                </div>
                <div class="text-right">
                    <div id="liveDate" class="text-[10px] font-black uppercase tracking-[0.2em] opacity-60"></div>
                    <div id="liveClock" class="text-3xl font-black mt-1 font-mono tracking-tighter"></div>
                </div>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-6 gap-6 mb-10">
                <div class="bg-white p-6 rounded-3xl shadow-lg border border-gray-50 flex flex-col justify-between">
                    <p class="text-gray-400 text-[9px] font-black uppercase tracking-widest">Gross Revenue</p>
                    <p class="text-2xl font-black text-emerald-600 mt-2 font-mono tracking-tighter">₹${totalRevenue}</p>
                    <p class="text-emerald-400 text-[8px] font-bold mt-1 uppercase tracking-wider">Realized Sales</p>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-lg border border-gray-50 flex flex-col justify-between">
                    <p class="text-gray-400 text-[9px] font-black uppercase tracking-widest">Inventory List</p>
                    <p class="text-2xl font-black text-indigo-600 mt-2 font-mono tracking-tighter">${productCount}</p>
                    <p class="text-indigo-400 text-[8px] font-bold mt-1 uppercase tracking-wider">Total SKUs</p>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-lg border border-red-50 flex flex-col justify-between ${lowStockCount > 0 ? 'bg-red-50/20' : ''}">
                    <p class="text-gray-400 text-[9px] font-black uppercase tracking-widest">Stock Alerts</p>
                    <p class="text-2xl font-black ${lowStockCount > 0 ? 'text-red-500' : 'text-gray-400'} mt-2 font-mono tracking-tighter">${lowStockCount}</p>
                    <p class="text-red-400 text-[8px] font-bold mt-1 uppercase tracking-wider">Critical Levels</p>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-lg border border-gray-50 flex flex-col justify-between">
                    <p class="text-gray-400 text-[9px] font-black uppercase tracking-widest">Unassigned</p>
                    <p class="text-2xl font-black text-orange-500 mt-2 font-mono tracking-tighter">${countPending}</p>
                    <p class="text-orange-400 text-[8px] font-bold mt-1 uppercase tracking-wider">Action Needed</p>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-lg border border-gray-50 flex flex-col justify-between">
                    <p class="text-gray-400 text-[9px] font-black uppercase tracking-widest">Deployments</p>
                    <p class="text-2xl font-black text-blue-600 mt-2 font-mono tracking-tighter">${countShipped}</p>
                    <p class="text-blue-400 text-[8px] font-bold mt-1 uppercase tracking-wider">In Transit</p>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-lg border border-gray-50 flex flex-col justify-between">
                    <p class="text-gray-400 text-[9px] font-black uppercase tracking-widest">Fulfilled</p>
                    <p class="text-2xl font-black text-gray-900 mt-2 font-mono tracking-tighter">${countDeliveredToday}</p>
                    <p class="text-gray-400 text-[8px] font-bold mt-1 uppercase tracking-wider">Completed Total</p>
                </div>
            </div>

            <div class="grid grid-cols-3 gap-10">
                
                <!-- PENDING ORDERS — ASSIGN TO DELIVERY BOY -->
                <div class="col-span-2 bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-gray-100">
                    <div class="flex justify-between items-center p-8 border-b bg-gray-50/50">
                        <div>
                            <h2 class="text-2xl font-black text-gray-900 tracking-tight">⏳ Action Required</h2>
                            <p class="text-gray-400 text-[11px] font-black uppercase tracking-widest mt-1">Pending Assignment List</p>
                        </div>
                        <span class="bg-orange-500 text-white text-[10px] font-black px-5 py-2 rounded-full shadow-lg shadow-orange-100 uppercase tracking-widest"
                            id="pendingBadge">${countPending} Unassigned</span>
                    </div>
                    <div class="p-8 space-y-6" id="pendingOrdersList">
                        <c:if test="${empty pendingOrders}">
                            <div class="text-center py-16">
                                <p class="text-7xl mb-6">🏝️</p>
                                <p class="text-gray-400 font-black uppercase tracking-[0.2em] text-xs">All clear! No orders pending assignment.</p>
                            </div>
                        </c:if>

                        <c:forEach var="order" items="${pendingOrders}">
                            <div class="bg-white border-2 border-orange-50 rounded-[2rem] p-7 hover:border-orange-200 transition-all shadow-sm group" id="order-${order.id}">
                                <div class="flex justify-between items-start gap-8">
                                    <div class="flex-1">
                                        <div class="flex items-center gap-3 mb-2">
                                            <span class="font-black text-2xl text-gray-900 tracking-tighter">${order.orderNumber}</span>
                                            <span class="bg-orange-100 text-orange-600 text-[9px] font-black px-3 py-1 rounded-full uppercase tracking-widest border border-orange-200">${order.deliveryPriority}</span>
                                        </div>
                                        <div class="space-y-2">
                                            <p class="text-sm font-black text-gray-800 tracking-tight underline decoration-purple-100 decoration-4 underline-offset-2 capitalize">
                                                🏪 ${order.customer.shopName}
                                            </p>
                                            <p class="text-xs text-gray-500 font-medium opacity-80">${order.customer.area}, ${order.customer.city}</p>
                                            <div class="bg-gray-50 rounded-xl p-3 inline-block mt-2 border border-gray-100">
                                                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-1">Stock Out Plan</p>
                                                <p class="text-[11px] text-indigo-600 font-bold leading-relaxed">${order.itemsSummary}</p>
                                            </div>
                                            <div class="flex gap-4 mt-3">
                                                <p class="text-base font-black text-gray-900 font-mono tracking-tighter">₹${order.totalAmount}</p>
                                                <p class="text-xs text-gray-400 font-semibold tracking-tight border-l pl-4 border-gray-200">
                                                    📅 <fmt:formatDate value="${order.orderDate}" pattern="hh:mm a, dd MMM" />
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="w-64 flex flex-col gap-3">
                                        <label class="text-[9px] font-black text-gray-400 uppercase tracking-[0.2em] ml-1">Assign Deployment</label>
                                        <select id="delivery-select-${order.id}"
                                            class="bg-gray-50 border-2 border-gray-100 p-4 rounded-2xl text-xs font-black focus:border-indigo-400 outline-none transition cursor-pointer hover:bg-white shadow-inner">
                                            <option value="">— Select Personnel —</option>
                                            <c:forEach var="boy" items="${deliveryBoys}">
                                                <option value="${boy.id}">🛵 ${boy.fullName}</option>
                                            </c:forEach>
                                        </select>
                                        <button onclick="assignOrder(${order.id}, '${order.orderNumber}', 'delivery-select-${order.id}')"
                                            class="bg-indigo-600 text-white py-4 rounded-2xl font-black text-[10px] hover:bg-indigo-700 transition shadow-xl shadow-indigo-100 uppercase tracking-widest">
                                            🚀 Confirm Assignment
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- RIGHT SIDEBAR: ASSIGNED TRACKER -->
                <div class="space-y-8">
                    <div class="bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-gray-100">
                        <div class="p-8 border-b bg-gray-50/50">
                            <h2 class="text-xl font-black text-gray-900 tracking-tight">🛵 Live Deployments</h2>
                            <p class="text-[9px] text-blue-400 font-black uppercase tracking-[0.2em] mt-1">Personnel Activity Log</p>
                        </div>
                        <div class="max-h-[600px] overflow-y-auto pr-1">
                            <table class="w-full text-xs" id="assignedTable">
                                <tbody class="text-gray-700 divide-y divide-gray-50" id="assignedBody">
                                    <c:forEach var="ao" items="${assignedOrders}">
                                        <tr class="hover:bg-blue-50/30 transition-colors">
                                            <td class="py-6 px-6">
                                                <p class="font-black text-gray-900">${ao.orderNumber}</p>
                                                <p class="text-[9px] text-gray-400 font-black uppercase tracking-widest mt-0.5 truncate w-24">${ao.customer.shopName}</p>
                                            </td>
                                            <td class="px-6">
                                                <p class="text-blue-600 font-black">🛵 ${ao.deliveryBoy.fullName}</p>
                                                <span class="bg-blue-50 text-blue-500 px-2 py-0.5 rounded-full text-[8px] font-black uppercase mt-1 inline-block border border-blue-100">In Transit</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="hidden fixed bottom-10 right-10 bg-gray-900 text-white px-8 py-5 rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.3)] font-black text-xs z-50 uppercase tracking-[0.2em] animate-bounce-short"></div>

    <script>
        function assignOrder(orderId, orderNum, selectId) {
            const sel = document.getElementById(selectId);
            const staffId = sel.value;
            if (!staffId) { alert('⚠️ Alert: Active personnel must be designated.'); return; }

            const staffName = sel.options[sel.selectedIndex].text;

            fetch('${pageContext.request.contextPath}/manager/assignOrder', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'orderId=' + orderId + '&staffId=' + staffId
            })
            .then(res => res.text())
            .then(text => {
                if (text === 'Success') {
                    showToast('✅ ' + orderNum + ' DEPLOYED WITH ' + staffName);
                    setTimeout(() => location.reload(), 2000);
                } else alert(text);
            });
        }

        function showToast(msg) {
            const t = document.getElementById('toast');
            t.innerText = msg; t.classList.remove('hidden');
            setTimeout(() => t.classList.add('hidden'), 4000);
        }

        setInterval(() => {
            const now = new Date();
            document.getElementById('liveClock').innerText = now.toLocaleTimeString('en-US', { hour12: false });
            document.getElementById('liveDate').innerText = now.toLocaleDateString('en-US', { weekday: 'long', month: 'short', day: 'numeric' });
        }, 1000);
    </script>
</body>
</html>