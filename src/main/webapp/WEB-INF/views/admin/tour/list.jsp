<%@ include file="/common/taglib.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:url var="tourAPI" value="/api/tour" />
<c:url var="tourURL" value="/quan-tri/tour/danh-sach"/>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Danh sách Tour</title>
</head>

<body>
<div class="main-content">
    <form action='<c:url value="/quan-tri/tour/danh-sach"/>' id="formSubmit" method="get">

        <div class="main-content-inner">
            <div class="breadcrumbs ace-save-state" id="breadcrumbs">
                <ul class="breadcrumb">
                    <li><i class="ace-icon fa fa-home home-icon"></i> <a href="<c:url value='/quan-tri/trang-chu' /> ">Trang
                        chủ</a></li>
                    <li class="active">Tour</li>
                </ul>
                <!-- /.breadcrumb -->
            </div>
            <div class="page-content">
                <div class="row">
                    <div class="col-xs-12">
                        <c:if test="${not empty message}">
                            <div class="alert alert-${alert}">
                                <button type="button" class="close" data-dismiss="alert">
                                    <i class="ace-icon fa fa-times"></i>
                                </button>
                                <strong>${message}</strong>
                            </div>
                        </c:if>
                        <div class="widget-box table-detail">
                            <div class="table-btn-controls">
                                <div class="pull-right tableTools-container">
                                    <div class="dt-buttons btn-overlap btn-group">
                                        <c:url var="createTourURL" value="/quan-tri/tour/chinh-sua" />
                                        <a flag="info" class="dt-button-info buttons-colvis btn btn-white btn-primary btn-bold
                                                        " data-toggle="tooltip" title="Thêm mới"
                                           href='${createTourURL}'>
                                                        <span>
                                                            <i class="fa fa-plus-circle bigger-110 purple"></i>
                                                        </span>
                                        </a>
                                        <button id="btnDelete" type="button" onclick="warningBeforeDelete()"
                                                class="dt-button-info buttons btn btn-white btn-primary btn-bold"
                                                data-toggle="tooltip"
                                                title="Xóa" href="#" disabled>
                                                            <span>
                                                                <i class="fa fa-trash-o bigger-110 pink"></i>
                                                            </span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="table-responsive">
                                    <table class="table table-bordered center">
                                        <thead>
                                        <tr>
                                            <th class="center"><input type="checkbox" id="checkAll"></th>
                                            <th class="center">Ảnh</th>
                                            <th class="center">Tên tour</th>
                                            <th class="center">Description</th>
                                            <th class="center">Địa danh</th>
                                            <th class="center">Thao tác</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="item" items="${model.listResult}">
                                            <tr>
                                                <td><input type="checkbox" id="checkbox_${item.id}" value="${item.id}"></td>
                                                <td><img style="width: 150px; height: 100px" src="<c:url value='/template/web/image/${item.thumbnailUrl}'/>"/></td>
                                                <td>${item.name}</td>
                                                <td>${item.description}</td>
                                                <td>
                                                <c:forEach var="place" items="${item.places}" varStatus="loop">
                                                    ${place.name}
                                                    <c:if test="${!loop.last}"> - </c:if>
                                                </c:forEach>
                                                </td>
                                                <td>
                                                    <c:url var="updateTourURL" value="/quan-tri/tour/chinh-sua">
                                                        <c:param name="id" value="${item.id}"/>
                                                    </c:url>
                                                    <a class="btn btn-sm btn-primary btn-edit" data-toggle="tooltip"
                                                       title="Cập nhật" href='${updateTourURL}'>
                                                        <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                                    </a>

                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                    <center><ul class="pagination" id="pagination"></ul></center>
                                    <input type="hidden" value="" id="page" name="page"/>
                                    <input type="hidden" value="" id="limit" name="limit"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<!-- main content -->
<script>
    var currentPage = ${model.page};
    var totalPage = ${model.totalPage};
    $(function () {
        window.pagObj = $('#pagination').twbsPagination({
            totalPages: totalPage,
            visiblePages: 10,
            startPage: currentPage,
            onPageClick: function (event, page) {
                if (currentPage != page) {
                    $('#limit').val(5);
                    $('#page').val(page);
                    $('#formSubmit').submit();
                }
            }
        })
    });

    var checkboxes = $("tbody input[type='checkbox']"),
        submitButt = $("button[type='button']");

    checkboxes.click(function() {
        submitButt.attr("disabled", !checkboxes.is(":checked"));
    });
    $("#checkAll").change(function (){
        $("input:checkbox").prop('checked', $(this).prop("checked"));
    });
    function warningBeforeDelete() {
        swal({
            title: "Xác nhận xóa",
            text: "Bạn có chắc chắn muốn xóa hay không",
            type: "warning",
            showCancelButton: true,
            confirmButtonClass: "btn-success",
            cancelButtonClass: "btn-danger",
            confirmButtonText: "Xác nhận",
            cancelButtonText: "Hủy",
        }).then(function(isConfirm) {
            if (isConfirm.dismiss) {
            }
            else {
                var ids = $('tbody input[type=checkbox]:checked').map(function () {
                    return $(this).val();
                }).get();
                deleteTour(ids);
            }
        });
    }
    function deleteTour(data) {
        $.ajax({
            url: '${tourAPI}',
            type: 'DELETE',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (result) {
                window.location.href = "${tourURL}?page=1&limit=5&message=delete_success";
            },
            error: function (error) {
                window.location.href = "${tourURL}?page=1&limit=5&message=error_system";
            }
        });
    }
</script>
</body>

</html>