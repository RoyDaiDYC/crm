package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.FileUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.settings.service.UserService;
import com.yuchengdai.crm.workbench.domain.MarketingActivities;
import com.yuchengdai.crm.workbench.domain.MarketingActivitiesRemark;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesRemarkService;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesService;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * RoyDai
 * 2017/3/12   15:23
 */
@Controller
public class ActivityController {


    private MarketingActivitiesService marketingActivitiesService;

    private UserService userService;

    private MarketingActivitiesRemarkService marketingActivitiesRemarkService;

    @Autowired
    public ActivityController setMarketingActivitiesService(MarketingActivitiesService marketingActivitiesService) {
        this.marketingActivitiesService = marketingActivitiesService;
        return this;
    }

    @Autowired
    public ActivityController setUserService(UserService userService) {
        this.userService = userService;
        return this;
    }

    @Autowired
    public ActivityController setMarketingActivitiesRemarkService(MarketingActivitiesRemarkService marketingActivitiesRemarkService) {
        this.marketingActivitiesRemarkService = marketingActivitiesRemarkService;
        return this;
    }

    /**
     * 跳转到主页面
     *
     * @return
     */
    @RequestMapping(value = "/workbench/activity/toIndex.do", method = RequestMethod.GET)
    public String toIndex() {
        return "workbench/activity/index";
    }


    /**
     * 获取所有用户信息
     * 提供到工作区
     *
     * @return
     */
    @RequestMapping(value = "/workbench/activity/getAllUsers.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getAllUsers() {
        return userService.queryAllUsers();
    }


    /**
     * 创建一个新的市场活动数据
     *
     * @param marketingActivities
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/activity/saveCreateMarketActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateMarketActivity(MarketingActivities marketingActivities,
                                           HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        //设置市场活动的id
        marketingActivities.setId(YuChengUID.getNoHyphenUUID());
        //设置市场活动创建的时间
        marketingActivities.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //设置市场活动创建人，通过session的id赋值
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        marketingActivities.setCreateBy(user.getId());

        try {
            int i = marketingActivitiesService.addMarketingActivities(marketingActivities);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("创建成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("创建失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，创建失败");
        }
        return returnObject;
    }

    /**
     * 获取市场活动内容
     * 通过筛选条件获取
     * 对分页内容，页号和每页内容设置当没有传参时用默认值1和5
     *
     * @param name
     * @param owner
     * @param startDate
     * @param endDate
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/workbench/activity/getMarketingActivitiesByCondition.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getMarketingActivitiesByCondition(
            String name, String owner, String startDate, String endDate,
            @RequestParam(required = false, defaultValue = "1") int pageNo,
            @RequestParam(required = false, defaultValue = "5") int pageSize) {
        int beginNo = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        PaginationResultVO<MarketingActivities> prVO = marketingActivitiesService.queryMarketingActivitiesForDetailByCondition(map);
        return prVO;
    }

    /**
     * 通过id获取市场活动信息
     * 返回响应时，返回查询到的此市场活动内容和，所有用户表内容
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/activity/toModifyMarketingActivitiesById.do", method = RequestMethod.POST)
    @ResponseBody
    public Object toModifyMarketingActivitiesById(String id) {
        Map<String, Object> map = new HashMap<>();
        MarketingActivities marketingActivities = marketingActivitiesService.queryMarketingActivitiesById(id);
        List<User> userList = userService.queryAllUsers();
        map.put("userList", userList);
        map.put("marketingActivities", marketingActivities);
        return map;
    }

    /**
     * 通过id更新市场活动内容
     * 更新内容追加修改者id和修改时间
     * 修改者id是当前登录账户的id
     *
     * @param marketingActivities
     * @return
     */
    @RequestMapping(value = "/workbench/activity/modifyMarketingActivities.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyMarketingActivities(MarketingActivities marketingActivities,
                                            HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        marketingActivities.setEditBy(user.getId());
        marketingActivities.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        try {
            int i = marketingActivitiesService.editMarketingActivitiesById(marketingActivities);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("更新成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，更新失败");
        }
        return returnObject;
    }


    /**
     * 通过id删除对应的市场活动内容
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/activity/deleteActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeMarketingActivities(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = marketingActivitiesService.deleteMarketingActivitiesById(id);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("成功删除" + i + "条内容");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，删除失败");
        }
        return returnObject;
    }

    /**
     * 接收市场活动名称模糊搜索，返回对应的市场活动集合
     *
     * @param activityName
     * @return
     */
    @RequestMapping(value = "/workbench/activity/searchActivitiesByName.do", method = RequestMethod.POST)
    @ResponseBody
    public Object searchActivitiesByName(String activityName) {
        List<MarketingActivities> marketingActivitiesList = marketingActivitiesService.queryMarketingActivitiesForDetailByName(activityName);
        return marketingActivitiesList;
    }


    /**
     * 下载文件
     * 通过POI把查询到的数据库表封装成Excel
     * 通过输出流写入服务器磁盘，再通过响应输出流返回浏览器
     *
     * @param request
     * @param response
     * @throws IOException
     */
    @RequestMapping(value = "/workbench/activity/downloadAll.do", method = RequestMethod.GET)
    public void exportAllMarketingActivities(HttpServletRequest request,
                                             HttpServletResponse response) throws IOException {
        List<MarketingActivities> activitiesList = marketingActivitiesService.queryAllMarketingActivitiesForDetail();
        /*
         * 把查询到的结果转换成Excel，存放在服务器上
         * 通过POI
         * */
        //1在服务器内存中创建一个Excel文件，文件在内存中
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        //2在Excel内创建页，工作簿
        HSSFSheet sheet = hssfWorkbook.createSheet();
        //3创建标题行，0为首行
        HSSFRow titleRow = sheet.createRow(0);
        //4给首行内容每一列输入内容0代表第一列
        titleRow.createCell(0).setCellValue("ID");
        titleRow.createCell(1).setCellValue("所有者");
        titleRow.createCell(2).setCellValue("名称");
        titleRow.createCell(3).setCellValue("开始时间");
        titleRow.createCell(4).setCellValue("结束时间");
        titleRow.createCell(5).setCellValue("成本");
        titleRow.createCell(6).setCellValue("描述");
        titleRow.createCell(7).setCellValue("创建时间");
        titleRow.createCell(8).setCellValue("创建人");
        titleRow.createCell(9).setCellValue("修改时间");
        titleRow.createCell(10).setCellValue("修改人");
        //5给首行标题设定Excel格式
        HSSFCellStyle cellStyle = hssfWorkbook.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        for (int i = 0; i < 10; i++) {
            titleRow.createCell(i).setCellStyle(cellStyle);
        }
        //6遍历所有内容，写入Excel表内
        //先进行判断获取的内容集合是否为null或里面是否有元素
        if (activitiesList != null && activitiesList.size() > 0) {
            int rowsNo = 0;
            HSSFRow row = null;
            //7遍历一次获取一个元素对应一行数据，把一行内的每个字段放对应表位置
            for (MarketingActivities activities : activitiesList) {
                //8获取每次要写入的行号，之前用了标题行的0行号，所以从1行开始写入
                rowsNo = sheet.getLastRowNum() + 1;
                row = sheet.createRow(rowsNo);
                row.createCell(0).setCellValue(activities.getId());
                row.createCell(1).setCellValue(activities.getOwner());
                row.createCell(2).setCellValue(activities.getName());
                row.createCell(3).setCellValue(activities.getStartDate());
                row.createCell(4).setCellValue(activities.getEndDate());
                row.createCell(5).setCellValue(activities.getCost());
                row.createCell(6).setCellValue(activities.getDescription());
                row.createCell(7).setCellValue(activities.getCreateTime());
                row.createCell(8).setCellValue(activities.getCreateBy());
                row.createCell(9).setCellValue(activities.getEditTime());
                row.createCell(10).setCellValue(activities.getEditBy());
            }
        }
        //9创建Excel文件名
        String fileName = "市场活动" + DateFormatUtil.getNoHyphenNowDateWithyyyyMMddHHmmss() + ".xls";
        //***这里需要注意，输出流是服务器创建的，不需要手动关闭，由服务器自动关闭
        try {
            //10获取浏览器信息，对文件名重新编码
            fileName = FileUtil.filenameEncoding(fileName, request);
            //11设置信息头
            response.setContentType("application/octet-stream;charset=utf-8");
            //12设置下载时显示方式，Content-Disposition是下载时不直接打开而且弹出下载窗口
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            //13获取输出流对象，通过参数HttpServletResponse调用
            ServletOutputStream outputStream = response.getOutputStream();
            //14写入文件内容

            hssfWorkbook.write(outputStream);

        } catch (IOException e) {
            e.printStackTrace();
            throw new IOException();
        } finally {
            //15关闭自定义POI创建的流
            hssfWorkbook.close();
        }

    }

    /**
     * 对选中的内容导出
     *
     * @param id
     * @param request
     * @param response
     * @throws IOException
     */
    @RequestMapping(value = "/workbench/activity/downloadById.do", method = RequestMethod.GET)
    public void exportMarketingActivitiesByIds(String[] id,
                                               HttpServletRequest request,
                                               HttpServletResponse response) throws IOException {
        List<MarketingActivities> activitiesList = marketingActivitiesService.queryMarketingActivitiesForDetailByIds(id);
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet();
        HSSFRow titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("ID");
        titleRow.createCell(1).setCellValue("所有者");
        titleRow.createCell(2).setCellValue("名称");
        titleRow.createCell(3).setCellValue("开始时间");
        titleRow.createCell(4).setCellValue("结束时间");
        titleRow.createCell(5).setCellValue("成本");
        titleRow.createCell(6).setCellValue("描述");
        titleRow.createCell(7).setCellValue("创建时间");
        titleRow.createCell(8).setCellValue("创建人");
        titleRow.createCell(9).setCellValue("修改时间");
        titleRow.createCell(10).setCellValue("修改人");
        if (activitiesList != null && activitiesList.size() > 0) {
            int rowNum = 0;
            HSSFRow row = null;
            for (MarketingActivities activities : activitiesList) {
                rowNum = sheet.getLastRowNum() + 1;
                row = sheet.createRow(rowNum);
                row.createCell(0).setCellValue(activities.getId());
                row.createCell(1).setCellValue(activities.getOwner());
                row.createCell(2).setCellValue(activities.getName());
                row.createCell(3).setCellValue(activities.getStartDate());
                row.createCell(4).setCellValue(activities.getEndDate());
                row.createCell(5).setCellValue(activities.getCost());
                row.createCell(6).setCellValue(activities.getDescription());
                row.createCell(7).setCellValue(activities.getCreateTime());
                row.createCell(8).setCellValue(activities.getCreateBy());
                row.createCell(9).setCellValue(activities.getEditTime());
                row.createCell(10).setCellValue(activities.getEditBy());
            }
        }
        String fileName = "市场活动" + DateFormatUtil.getNoHyphenNowDateWithyyyyMMddHHmmss() + ".xls";
        try {
            fileName = FileUtil.filenameEncoding(fileName, request);
            response.setContentType("application/octet-stream;charset=utf-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            ServletOutputStream outputStream = response.getOutputStream();
            hssfWorkbook.write(outputStream);
        } catch (IOException e) {
            e.printStackTrace();
            throw new IOException();
        } finally {
            hssfWorkbook.close();
        }

    }

    /**
     * 市场活动模板Excel
     * 只有表头内容
     *
     * @param request
     * @param response
     * @throws IOException
     */
    @RequestMapping(value = "/workbench/activity/downloadMb.do", method = RequestMethod.GET)
    public void exportMarketingActivitiesTemplate(HttpServletRequest request,
                                                  HttpServletResponse response) throws IOException {
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet();
        HSSFRow titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("名称");
        titleRow.createCell(1).setCellValue("开始时间");
        titleRow.createCell(2).setCellValue("结束时间");
        titleRow.createCell(3).setCellValue("成本");
        titleRow.createCell(4).setCellValue("描述");
        String fileName = "市场活动模板.xls";

        try {
            fileName = FileUtil.filenameEncoding(fileName, request);
            response.setContentType("application/octet-stream;charset=utf-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            ServletOutputStream outputStream = response.getOutputStream();
            hssfWorkbook.write(outputStream);
        } catch (IOException e) {
            e.printStackTrace();
            throw new IOException();
        } finally {
            hssfWorkbook.close();
        }
    }

    /**
     * 上传文件，把文件单元格内容解析为字符串，插入数据库
     * 需要对MVC进行上传文件调用类配置
     *
     * @param file
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/activity/importFile.do", method = RequestMethod.POST)
    @ResponseBody
    public Object importMarketingActivities(MultipartFile file,
                                            HttpSession session) {
        /*
         *
         * */
        ReturnObject returnObject = new ReturnObject();
        //1根据业务需求，拥有着，创建者为上传文件的人，需要使用session返回当前用户信息
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        try {
            //2通过服务器提供的流读取文件
            InputStream inputStream = file.getInputStream();
            //3在内存中通过POI创建一个Excel文件,和读取文件的流建立关系
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(inputStream);
            //4获取Excel文件第一页，0代表第一页
            HSSFSheet sheet = hssfWorkbook.getSheetAt(0);
            //5创建市场活动集合
            List<MarketingActivities> marketingActivitiesList = new ArrayList<>();
            //6取到总行数
            int rowsNum = sheet.getLastRowNum();
            HSSFRow row = null;
            MarketingActivities marketingActivities = null;
            for (int i = 1; i <= rowsNum; i++) {
                //7获取行，排除标题头，从第二行开始读取
                row = sheet.getRow(i);
                //***对空白行进行检测，遇到空白行视为内容结束
                if (row == null)
                    break;
                //8创建市场活动
                marketingActivities = new MarketingActivities();
                //设定市场活动表的ID
                marketingActivities.setId(YuChengUID.getNoHyphenUUID());

                //***拥有着在具体业务协定下规定，当前为上传者
                marketingActivities.setOwner(user.getId());

                //读取文件内第三列,通过格式化工具转换成字符串，放在市场活动名称
                marketingActivities.setName(FileUtil.getValueFromCell(row.getCell(0)));

                //读取文件内第四列,通过格式化工具转换成字符串，放在市场活动开始日期
                marketingActivities.setStartDate(FileUtil.getValueFromCell(row.getCell(1)));

                //读取文件内第五列,通过格式化工具转换成字符串，放在市场活动结束日期
                marketingActivities.setEndDate(FileUtil.getValueFromCell(row.getCell(2)));

                //读取文件内第六列,通过格式化工具转换成字符串，放在市场活动成本
                marketingActivities.setCost(FileUtil.getValueFromCell(row.getCell(3)));

                //读取文件内第七列,通过格式化工具转换成字符串，放在市场活动描述
                marketingActivities.setDescription(FileUtil.getValueFromCell(row.getCell(4)));

                //创建时间为程序设定时间，当前时间
                marketingActivities.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());

                //***创建者在具体业务协定下规定，当前为上传者
                marketingActivities.setCreateBy(user.getId());

                //修改时间和修改者不进行设定
                //把创建好的市场活动放入集合中
                marketingActivitiesList.add(marketingActivities);
            }
            //9调用业务层方法存数据
            int i = marketingActivitiesService.addMarketingActivitiesList(marketingActivitiesList);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("成功导入" + i + "条内容");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("上传失败");
            }
            //10关闭POI自定义创建的流
            hssfWorkbook.close();
        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，上传失败");
            //throw new IOException();
        }
        return returnObject;
    }

    /**
     * 携带指定id的市场活动信息和对应的市场活动备注信息跳转到详细页
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/workbench/activity/toDetail.do", method = RequestMethod.GET)
    public String toMarketingActivitiesDetail(String id, Model model) {
        //通过id获取市场活动信息
        MarketingActivities marketingActivities = marketingActivitiesService.queryMarketingActivitiesForDetailById(id);
        //通过市场活动id获取对应的市场活动备注信息集合
        List<MarketingActivitiesRemark> marketingActivitiesRemarks = marketingActivitiesRemarkService.queryMarketingActivitiesRemarkByActivityId(id);
        //把市场活动和市场活动备注装箱
        model.addAttribute(marketingActivities);
        model.addAttribute(marketingActivitiesRemarks);
        return "workbench/activity/detail";
    }

}
