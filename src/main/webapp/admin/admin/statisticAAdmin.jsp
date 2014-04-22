<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<style type="text/css">
.dv-table td {
	border: 1 solid gray;
	font-size: 12px;
}
</style>

<table class="dv-table" border="0" style="width:100%;" >
	<tr>
		<td width="60px" align="center">汉字待编辑</td>
		<td width="60px" align="center">汉字等待审核</td>
		<td width="60px" align="center">汉字审核不通过</td>
		<td width="60px" align="center">汉字审核通过</td>
	</tr>
	<tr>
		<td width="60px" align="center"><s:property value="adminStatistic.hs.hanziS" />
		</td>
		<td width="60px" align="center"><s:property value="adminStatistic.hs.hanziE" />
		</td>
		<td width="60px" align="center"><s:property value="adminStatistic.hs.hanziVNP" />
		</td>
		<td width="60px" align="center"><s:property value="adminStatistic.hs.hanziVP" />
		</td>
	</tr>
	<tr>
		<td width="60px" align="center">词语已删除</td>
		<td width="60px" align="center">词语待审核</td>
		<td width="60px" align="center">词语审核不通过</td>
		<td width="60px" align="center">词语审核通过</td>
	</tr>
	<tr>
		<td width="60px" align="center"><s:property value="adminStatistic.cs.ciyuD" />
		</td>
		<td width="60px" align="center"><s:property value="adminStatistic.cs.ciyuDF" />
		</td>
		<td width="60px" align="center"><s:property value="adminStatistic.cs.ciyuVNP" />
		</td>
		<td width="60px" align="center"><s:property value="adminStatistic.cs.ciyuVP" />
		</td>
	</tr>

</table>

