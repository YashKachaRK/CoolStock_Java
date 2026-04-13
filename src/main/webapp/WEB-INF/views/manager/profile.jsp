<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Manager Profile | CoolStock</title>
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

                <div class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-10 rounded-[3rem] mb-10 flex justify-between items-center shadow-2xl relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-80 h-80 bg-white/10 rounded-full -mr-40 -mt-40 blur-3xl"></div>
                    <div>
                        <h1 class="text-4xl font-black tracking-tighter">👤 Executive Profile</h1>
                        <p class="opacity-80 mt-2 font-medium italic">Manage your operational credentials and organizational identity.</p>
                    </div>
                    <div class="text-right z-10">
                        <p class="text-[10px] font-black uppercase tracking-[0.3em] opacity-60">Staff ID</p>
                        <p class="text-3xl font-black font-mono tracking-tighter">${manager.staffKey}</p>
                    </div>
                </div>

                <div class="grid grid-cols-3 gap-10">
                    
                    <!-- Sidebar: Identity -->
                    <div class="space-y-8">
                        <div class="bg-white rounded-[2.5rem] shadow-xl p-10 text-center border border-gray-100 relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-24 h-24 bg-indigo-50 rounded-full -mr-12 -mt-12 blur-2xl"></div>
                            
                            <div class="w-40 h-40 bg-indigo-50 rounded-[2.5rem] mx-auto mb-8 flex items-center justify-center text-6xl border-8 border-white shadow-2xl rotate-3 transition-transform hover:rotate-0 duration-500">
                                👨‍💼
                            </div>
                            <h2 class="text-3xl font-black text-gray-900 tracking-tight leading-tight mb-2">${manager.fullName}</h2>
                            <span class="inline-block px-4 py-1.5 bg-indigo-600 text-white rounded-full text-[10px] font-black uppercase tracking-[0.2em] shadow-lg shadow-indigo-100">${manager.role}</span>
                            
                            <div class="space-y-5 py-8 border-y border-dashed border-gray-100 text-left mt-8">
                                <div class="flex items-center gap-4 group">
                                    <div class="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center group-hover:bg-indigo-50 transition-colors">📱</div>
                                    <div>
                                        <p class="text-[9px] text-gray-400 font-black uppercase tracking-widest">Contact</p>
                                        <p class="font-black text-gray-700 font-mono text-sm">${manager.phone}</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4 group">
                                    <div class="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center group-hover:bg-indigo-50 transition-colors">📧</div>
                                    <div>
                                        <p class="text-[9px] text-gray-400 font-black uppercase tracking-widest">Email</p>
                                        <p class="font-bold text-gray-600 text-xs truncate w-40">${manager.email}</p>
                                    </div>
                                </div>
                            </div>
                            
                            <p class="text-[9px] text-gray-300 font-black uppercase tracking-[0.3em] mt-8">Active Level: Senior Ops</p>
                        </div>
                    </div>

                    <!-- Main Content: Credentials & Security -->
                    <div class="col-span-2 space-y-10">
                        
                        <!-- Account Security -->
                        <div class="bg-white rounded-[3rem] shadow-2xl p-12 border border-gray-100 relative overflow-hidden">
                            <div class="absolute bottom-0 right-0 w-48 h-48 bg-gray-50 rounded-full -mr-24 -mb-24 opacity-50"></div>
                            
                            <h3 class="text-2xl font-black text-gray-900 mb-10 tracking-tighter flex items-center gap-4">
                                <span class="w-12 h-12 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center text-2xl shadow-sm">🔑</span> 
                                Security & Access Audit
                            </h3>

                            <c:if test="${not empty passSuccess}">
                                <div class="mb-10 bg-emerald-50 border border-emerald-100 p-5 rounded-3xl flex items-center gap-4 text-emerald-700 text-sm font-black shadow-inner">
                                    <span class="text-xl">✨</span> ${passSuccess}
                                </div>
                            </c:if>
                            <c:if test="${not empty passError}">
                                <div class="mb-10 bg-red-50 border border-red-100 p-5 rounded-3xl flex items-center gap-4 text-red-700 text-sm font-black shadow-inner">
                                    <span class="text-xl">⚠️</span> ${passError}
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/customer/updatePassword" method="POST" class="space-y-8">
                                <div class="grid grid-cols-2 gap-8">
                                    <div class="space-y-2">
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Proposed Password</label>
                                        <input type="password" name="newPassword" required 
                                            placeholder="••••••••"
                                            class="w-full bg-gray-50 border-2 border-gray-50 rounded-[1.5rem] px-6 py-4.5 text-sm font-black outline-none focus:bg-white focus:border-indigo-400 transition-all shadow-inner">
                                    </div>
                                    <div class="space-y-2">
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Confirm Proposal</label>
                                        <input type="password" name="confirmPassword" required 
                                            placeholder="••••••••"
                                            class="w-full bg-gray-50 border-2 border-gray-50 rounded-[1.5rem] px-6 py-4.5 text-sm font-black outline-none focus:bg-white focus:border-indigo-400 transition-all shadow-inner">
                                    </div>
                                </div>
                                
                                <div class="bg-indigo-50/50 rounded-3xl p-6 border border-indigo-100/50 flex align-start gap-4">
                                    <span class="text-xl mt-0.5">💡</span>
                                    <p class="text-xs font-bold text-indigo-700 leading-relaxed italic opacity-80">
                                        Cybersecurity Protocol: Updating your password will invalidate existing session keys on other devices. Use a combination of alpha-numeric characters for maximum entropy.
                                    </p>
                                </div>

                                <button type="submit" 
                                    class="w-full py-5 bg-gray-900 text-white font-black rounded-[1.5rem] hover:bg-black transition-all shadow-[0_15px_40px_rgba(0,0,0,0.15)] text-xs tracking-[0.2em] uppercase active:scale-[0.98]">
                                    REVOKE & REISSUE CREDENTIALS
                                </button>
                            </form>
                        </div>

                        <!-- System Records -->
                        <div class="bg-gray-900 rounded-[3rem] shadow-2xl p-12 text-white border border-gray-800">
                            <h3 class="text-2xl font-black mb-10 tracking-tighter flex items-center gap-4">
                                <span class="w-12 h-12 bg-gray-800 text-indigo-400 rounded-2xl flex items-center justify-center text-2xl">📋</span> 
                                Personnel Registry Detail
                            </h3>
                            <div class="grid grid-cols-2 gap-10">
                                <div class="space-y-1">
                                    <p class="text-[10px] text-gray-500 font-black uppercase tracking-widest">Full Name (Legal)</p>
                                    <p class="text-lg font-black tracking-tight">${manager.fullName}</p>
                                </div>
                                <div class="space-y-1">
                                    <p class="text-[10px] text-gray-500 font-black uppercase tracking-widest">Role Hierarchy</p>
                                    <p class="text-lg font-black tracking-tight text-indigo-400 underline decoration-indigo-500 underline-offset-8">${manager.role}</p>
                                </div>
                                <div class="col-span-2 space-y-1">
                                    <p class="text-[10px] text-gray-500 font-black uppercase tracking-widest">Internal Contact Email</p>
                                    <p class="text-lg font-black tracking-tight font-mono">${manager.email}</p>
                                </div>
                            </div>
                            
                            <div class="mt-12 pt-8 border-t border-gray-800 flex justify-between items-center bg-gray-800/20 -mx-12 px-12 pb-1">
                                <div>
                                    <p class="text-[9px] text-gray-500 font-black uppercase tracking-[0.2em]">Deployment Date</p>
                                    <p class="text-xs font-bold text-gray-300 mt-1"><fmt:formatDate value="${manager.joinedDate}" pattern="dd MMM yyyy, HH:mm" /></p>
                                </div>
                                <div class="text-right">
                                    <p class="text-[9px] text-emerald-500 font-black uppercase tracking-[0.2em]">Account Status</p>
                                    <p class="text-xs font-black text-white mt-1 uppercase tracking-widest">✓ ACTIVE OPERATOR</p>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="mt-16 text-center text-gray-400 text-[10px] font-black uppercase tracking-[0.5em]">
                    CoolStock Enterprise Resource Planning • V2.0.4 • OPS-SEC
                </div>
            </div>
    </div>
</body>
</html>