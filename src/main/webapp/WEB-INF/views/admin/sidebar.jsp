<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <div class="w-64 h-screen bg-slate-800 text-white fixed flex flex-col justify-between overflow-y-auto">
        <div>
            <!-- Brand -->
            <div class="p-5 border-b border-slate-700 flex items-center gap-3">
                <span class="text-2xl">🍦</span>
                <div>
                    <h2 class="text-lg font-black">CoolStock</h2>
                    <p class="text-xs text-slate-400">Admin Panel</p>
                </div>
            </div>

            <nav class="mt-4 space-y-1 px-3">

                <!-- Overview -->
                <p class="text-xs text-slate-500 uppercase font-bold px-3 pt-2 pb-1">Overview</p>

                <a href="${pageContext.request.contextPath}/admin/dashboard"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>🏠</span> Dashboard
                </a>

                <!-- Management -->
                <p class="text-xs text-slate-500 uppercase font-bold px-3 pt-4 pb-1">Management</p>

                <a href="${pageContext.request.contextPath}/admin/products"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>📦</span> Manage Products
                </a>

                <a href="${pageContext.request.contextPath}/admin/orders"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>🧾</span> Recent Orders
                </a>

                <a href="${pageContext.request.contextPath}/admin/staff"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>👥</span> Manage Staff
                </a>

                <a href="${pageContext.request.contextPath}/admin/customers"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>🏪</span> Manage Customers
                </a>

                <!-- Account -->
                <p class="text-xs text-slate-500 uppercase font-bold px-3 pt-4 pb-1">Account</p>

                <a href="${pageContext.request.contextPath}/admin/profile"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>👤</span> My Profile
                </a>

            </nav>
        </div>

        <!-- Logout -->
        <div class="mb-5 px-4 pb-2">
            <a href="${pageContext.request.contextPath}/logout"
                class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm">
                🚪 Logout
            </a>
        </div>
    </div>