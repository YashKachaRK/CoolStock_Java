<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
				<!DOCTYPE html>
				<html lang="en">

				<head>
					<meta charset="UTF-8">
					<meta name="viewport" content="width=device-width, initial-scale=1.0">
					<title>Admin Dashboard | CoolStock</title>
					<script src="https://cdn.tailwindcss.com"></script>
					<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap"
						rel="stylesheet">
					<style>
						body {
							font-family: 'Outfit', sans-serif;
						}

						@keyframes fadeInUp {
							from {
								opacity: 0;
								transform: translateY(16px);
							}

							to {
								opacity: 1;
								transform: translateY(0);
							}
						}

						.fade-in {
							animation: fadeInUp 0.4s ease forwards;
						}

						@keyframes slideIn {
							from {
								opacity: 0;
								transform: translateX(60px);
							}

							to {
								opacity: 1;
								transform: translateX(0);
							}
						}

						#toast {
							animation: slideIn 0.3s ease;
						}
					</style>
				</head>

				<body class="bg-gray-100 min-h-screen">
					<div class="flex">

						<%@ include file="sidebar.jsp" %>

							<div class="ml-64 p-8 w-full">

								<!-- ── Header ──────────────────────────────────────────────────── -->
								<div
									class="bg-gradient-to-r from-slate-800 to-gray-700 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
									<div>
										<h1 class="text-3xl font-black">⚙️ Admin Control Panel</h1>
										<p class="opacity-80 mt-1">CoolStock — Ice Cream Wholesale System</p>
									</div>
									<div class="text-right">
										<div id="liveDate" class="text-sm opacity-70"></div>
										<div id="liveClock" class="text-2xl font-bold mt-1"></div>
									</div>
								</div>

								<!-- ── Stats Overview ──────────────────────────────────────────── -->
								<div class="grid grid-cols-5 gap-6 mb-8">
									<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
										<p class="text-gray-400 text-sm">Total Customers</p>
										<p class="text-3xl font-black text-slate-700 mt-2">${totalCustomers}</p>
										<p class="text-green-500 text-xs mt-1">Customers added dynamically</p>
									</div>
									<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
										<p class="text-gray-400 text-sm">Total Employees</p>
										<p class="text-3xl font-black text-blue-600 mt-2">${totalEmployees}</p>
										<p class="text-gray-400 text-xs mt-1">Manager · Delivery · Cashier</p>
									</div>
									<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
										<p class="text-gray-400 text-sm">Orders This Month</p>
										<p class="text-3xl font-black text-purple-600 mt-2">${ordersThisMonth}</p>
										<p class="text-green-500 text-xs mt-1">Updated in real-time</p>
									</div>
									<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
										<p class="text-gray-400 text-sm">Pending Join Requests</p>
										<p class="text-3xl font-black text-orange-500 mt-2">${pendingCount}</p>
										<p class="text-orange-400 text-xs mt-1">Awaiting approval</p>
									</div>
									<div
										class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition ${expiringSoonCount > 0 ? 'bg-orange-50 border border-orange-200' : ''}">
										<p class="text-gray-400 text-sm">Expiry Alerts</p>
										<p
											class="text-3xl font-black ${expiringSoonCount > 0 ? 'text-orange-600' : 'text-gray-400'} mt-2">
											${expiringSoonCount}</p>
										<p class="text-orange-400 text-xs mt-1">Near Expiration</p>
									</div>
								</div>

								<!-- ── Join Requests Section ───────────────────────────────────── -->
								<div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">

									<!-- Section header -->
									<div class="flex justify-between items-center p-6 border-b bg-orange-50">
										<div>
											<h2 class="text-xl font-bold text-gray-800">📋 New Join Requests</h2>
											<p class="text-gray-400 text-sm mt-0.5">Review applicants from the website's
												Apply form</p>
										</div>
										<span
											class="bg-orange-500 text-white text-sm font-bold px-4 py-1.5 rounded-full">
											${pendingCount} Pending
										</span>
									</div>

									<!-- Filter tabs -->
									<div class="flex gap-2 px-6 pt-5 pb-1">
										<button onclick="filterCards('ALL')" id="tab-ALL"
											class="tab-btn active-tab px-4 py-1.5 rounded-full text-sm font-semibold transition">All</button>
										<button onclick="filterCards('PENDING')" id="tab-PENDING"
											class="tab-btn px-4 py-1.5 rounded-full text-sm font-semibold transition">⏳
											Pending</button>
										<button onclick="filterCards('ACCEPTED')" id="tab-ACCEPTED"
											class="tab-btn px-4 py-1.5 rounded-full text-sm font-semibold transition">✅
											Accepted</button>
										<button onclick="filterCards('REJECTED')" id="tab-REJECTED"
											class="tab-btn px-4 py-1.5 rounded-full text-sm font-semibold transition">❌
											Rejected</button>
									</div>

									<style>
										.tab-btn {
											background: #f3f4f6;
											color: #4b5563;
										}

										.active-tab {
											background: #f97316;
											color: #ffffff;
										}
									</style>

									<!-- Cards container -->
									<div class="p-6 space-y-4" id="requestsList">

										<c:choose>
											<c:when test="${empty applications}">
												<!-- Empty state -->
												<div class="py-16 text-center text-gray-400">
													<div class="text-6xl mb-4">📭</div>
													<p class="font-semibold text-lg">No applications yet</p>
													<p class="text-sm mt-1">Applications submitted from the website will
														appear here.</p>
												</div>
											</c:when>
											<c:otherwise>
												<c:forEach var="app" items="${applications}">
													<%-- Determine avatar colour per role --%>
														<c:choose>
															<c:when test="${fn:containsIgnoreCase(app.role,'Manager')}">
																<c:set var="avatarBg" value="bg-indigo-100" />
																<c:set var="roleColor" value="text-indigo-600" />
																<c:set var="roleEmoji" value="📊" />
															</c:when>
															<c:when test="${fn:containsIgnoreCase(app.role,'Cashier')}">
																<c:set var="avatarBg" value="bg-yellow-100" />
																<c:set var="roleColor" value="text-yellow-600" />
																<c:set var="roleEmoji" value="💳" />
															</c:when>
															<c:otherwise>
																<c:set var="avatarBg" value="bg-orange-100" />
																<c:set var="roleColor" value="text-orange-600" />
																<c:set var="roleEmoji" value="🛵" />
															</c:otherwise>
														</c:choose>

														<%-- Determine status badge --%>
															<c:choose>
																<c:when test="${app.status == 'ACCEPTED'}">
																	<c:set var="statusBadge"
																		value="bg-green-100 text-green-700" />
																	<c:set var="statusLabel" value="✅ Accepted" />
																</c:when>
																<c:when test="${app.status == 'REJECTED'}">
																	<c:set var="statusBadge"
																		value="bg-red-100 text-red-600" />
																	<c:set var="statusLabel" value="❌ Rejected" />
																</c:when>
																<c:otherwise>
																	<c:set var="statusBadge"
																		value="bg-orange-100 text-orange-600" />
																	<c:set var="statusLabel" value="⏳ Pending" />
																</c:otherwise>
															</c:choose>

															<div class="app-card border-2 border-gray-100 rounded-2xl p-5 hover:border-orange-200 transition fade-in"
																data-status="${app.status}" id="card-${app.id}">

																<div class="flex justify-between items-start">

																	<!-- Left: applicant info -->
																	<div class="flex items-center gap-4">
																		<div
																			class="w-12 h-12 ${avatarBg} rounded-2xl flex items-center justify-center text-2xl flex-shrink-0">
																			${roleEmoji}
																		</div>
																		<div>
																			<p class="font-bold text-gray-800 text-lg">
																				${app.fullName}</p>
																			<p class="text-gray-500 text-sm">
																				📞 ${app.phone} &nbsp;|&nbsp; 📧
																				${app.email}
																			</p>
																			<p class="text-gray-400 text-xs mt-1">
																				Applied for:
																				<span
																					class="font-semibold ${roleColor}">${app.role}</span>
																				&nbsp;|&nbsp;
																				<fmt:formatDate value="${app.appliedAt}"
																					pattern="dd MMM yyyy" type="date" />
																				<c:if test="${app.appliedAt == null}">—
																				</c:if>
																				&nbsp;|&nbsp;
																				<span
																					class="font-semibold px-2 py-0.5 rounded-full text-xs ${statusBadge}">${statusLabel}</span>
																			</p>
																		</div>
																	</div>

																	<!-- Right: action buttons (only for PENDING) -->
																	<c:if test="${app.status == 'PENDING'}">
																		<div class="flex gap-3 flex-shrink-0">

																			<!-- Approve form -->
																			<form
																				action="${pageContext.request.contextPath}/admin/applications/approve"
																				method="post" style="display:inline;">
																				<input type="hidden" name="id"
																					value="${app.id}">
																				<button type="submit"
																					class="bg-green-500 text-white px-5 py-2 rounded-xl font-semibold hover:bg-green-600 transition text-sm">
																					✅ Approve
																				</button>
																			</form>

																			<!-- Reject form -->
																			<form
																				action="${pageContext.request.contextPath}/admin/applications/reject"
																				method="post" style="display:inline;">
																				<input type="hidden" name="id"
																					value="${app.id}">
																				<button type="submit"
																					class="bg-red-100 text-red-600 px-5 py-2 rounded-xl font-semibold hover:bg-red-200 transition text-sm">
																					❌ Reject
																				</button>
																			</form>
																		</div>
																	</c:if>
																</div>

																<!-- Cover letter -->
																<c:if test="${not empty app.coverLetter}">
																	<div
																		class="mt-3 ml-16 text-sm text-gray-500 bg-gray-50 rounded-xl p-3">
																		<span class="font-semibold">Cover Note:</span>
																		"${app.coverLetter}"
																	</div>
																</c:if>
															</div>
												</c:forEach>
											</c:otherwise>
										</c:choose>

									</div><!-- /requestsList -->
								</div>

								<!-- ── Current Staff List ─────────────────────────────────────── -->
								<div class="bg-white rounded-2xl shadow-lg overflow-hidden">
									<div class="p-6 border-b">
										<h2 class="text-xl font-bold text-gray-800">👥 Current Active Staff</h2>
									</div>
									<table class="w-full text-sm">
										<thead class="bg-gray-50 text-gray-500 uppercase text-xs">
											<tr>
												<th class="py-3 px-6 text-left">Name</th>
												<th class="px-6 text-left">Role</th>
												<th class="px-6 text-left">Email</th>
												<th class="px-6 text-left">Status</th>
											</tr>
										</thead>
										<tbody class="text-gray-700">
											<c:forEach var="staff" items="${activeStaff}">
												<tr class="border-b hover:bg-gray-50">
													<td class="py-3 px-6 font-semibold">${staff.fullName}</td>
													<td class="px-6">
														<c:choose>
															<c:when test="${staff.role == 'Manager'}">📊 Manager
															</c:when>
															<c:when test="${staff.role == 'Delivery'}">🛵 Delivery
															</c:when>
															<c:otherwise>💳 ${staff.role}</c:otherwise>
														</c:choose>
													</td>
													<td class="px-6 text-gray-400">${staff.email}</td>
													<td class="px-6">
														<c:if test="${staff.active}">
															<span
																class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs">Active</span>
														</c:if>
													</td>
												</tr>
											</c:forEach>
											<c:if test="${empty activeStaff}">
												<tr>
													<td colspan="4" class="py-4 text-center text-gray-400">No active
														staff found.</td>
												</tr>
											</c:if>
										</tbody>
									</table>
								</div>

							</div><!-- /main content -->
					</div><!-- /flex -->

					<!-- ── Toast notification ────────────────────────────────────────────── -->
					<c:if test="${not empty toastMsg}">
						<div id="toast" class="fixed bottom-6 right-6 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50
	            ${toastMsg == 'ACCEPTED' ? 'bg-green-500' : 'bg-red-500'}">
							${toastMsg == 'ACCEPTED' ? '✅ Application Approved!' : '❌ Application Rejected.'}
						</div>
						<script>setTimeout(() => { const t = document.getElementById('toast'); if (t) t.remove(); }, 3500);</script>
					</c:if>

					<!-- ── Scripts ────────────────────────────────────────────────────────── -->
					<script>
						// Live clock
						setInterval(() => {
							const now = new Date();
							document.getElementById('liveClock').innerText =
								String(now.getHours()).padStart(2, '0') + ':' +
								String(now.getMinutes()).padStart(2, '0') + ':' +
								String(now.getSeconds()).padStart(2, '0');
							document.getElementById('liveDate').innerText = now.toDateString();
						}, 1000);

						// Filter tabs
						function filterCards(status) {
							// Update active tab style
							document.querySelectorAll('.tab-btn').forEach(b => {
								b.classList.remove('active-tab');
								b.classList.add('tab-btn');
							});
							const active = document.getElementById('tab-' + status);
							if (active) { active.classList.add('active-tab'); }

							// Show/hide cards
							document.querySelectorAll('.app-card').forEach(card => {
								if (status === 'ALL' || card.dataset.status === status) {
									card.style.display = '';
								} else {
									card.style.display = 'none';
								}
							});
						}
					</script>

				</body>

				</html>