<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <title></title>
        <link rel="stylesheet" type="text/css" href="static/js/vender/bootstrap/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="static/js/vender/bootstrap-switch/css/bootstrap-switch.css"/>
        <link rel="stylesheet" type="text/css" href="static/themes/login/login.css">
    </head>
    <body>
        <div id="container" class="container well" style=" width: 500px; margin-bottom: 0">
            <div class="span6">
                <form method="post" action="" onsubmit="return doValidate()">
                    <fieldset>
                        <legend>登录</legend>
                        <div class="control-group text-center">
                            <div class="input-prepend">
                                        <span class="add-on">
                                            <div class="icon-user"></div>
                                        </span>
                                <input type="text" id="username" name="j_username" class="input-xlarge" placeholder="账号">
                            </div>
                        </div>
                        <div class="control-group text-center">
                            <div class="input-prepend">
                                        <span class="add-on">
                                            <div class="icon-lock"></div>
                                        </span>
                                <input type="password" id="password" name="j_password" class="input-xlarge" placeholder="密码">
                            </div>
                        </div>
                        <div class="control-group">
                            <div class="controls-row">
                                <div class="btn-group pull-right">
                                    <input class="btn btn-primary" type="submit" value="登录">
                                    <input class="btn btn-primary" type="reset" value="重置">
                                </div>
                            </div>
                            <span id="message" class="help-block" style="font-size: 12px; color: red; margin-top: -10px;"></span>
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
        <div class="form-shadow text-center container"></div>
        <div class="bottom-bar">
            <div class="copyright">
                © 版权所有 爱看书不识字 (本站不支持IE8及以下版本，请使用IE8+、Firefox5+、Chrome访问本站)
            </div>
        </div>
        <script src="static/js/vender/jquery-1.11.1.min.js"></script>
        <script src="static/js/vender/bootstrap/js/bootstrap.min.js"></script>
        <script src="static/js/vender/bootstrap-switch/js/bootstrap-switch.min.js"></script>
        <script type="text/javascript">
            $(function(){
                $('#username').focus();
                setFormPosition();
                setTooltip();
                showErrorMessage();
                setStatus();
            });

            function doValidate(){
                var username = $('#username').val();
                if(username.replace(/(^\s*)|(\s*$)/g, "") == ''){
                    $('#username').popover('show');
                    return false;
                }

                var password = $('#password').val();
                if(password.replace(/(^\s*)|(\s*$)/g, "") == ''){
                    $('#password').popover('show');
                    return false;
                }

                return true;
            }

            function setFormPosition(){
                $('#container').css({
                    'margin-top': function(){
                        return ($(this).height() / 2);
                    }
                });
            }

            function setTooltip(){
                $('#username').popover({
                    placement: 'bottom',
                    content: '请填写此输入项'
                }).tooltip({
                    trigger: 'hover',
                    placement: 'right',
                    title: '登录账号'
                }).keydown(function(event){
                    if($(this).val().length > 0){
                        $('#username').popover('hide');
                    }
                });

                $('#password').popover({
                    placement: 'bottom',
                    content: '请填写此输入项'
                }).tooltip({
                    trigger: 'hover',
                    placement: 'right',
                    title: '登录密码'
                }).keydown(function(event){
                    if($(this).val().length > 0){
                        $('#password').popover('hide');
                    }
                });
            }

            function showErrorMessage(){
                var searchStr = location.search;
                searchStr = searchStr.substr(1);
                var searchs = searchStr.split("&");
                if(searchs[0].indexOf('error') > -1){
                    $('#message').text('账号、密码错误！');
                }
            }
        </script>
    </body>
</html>
