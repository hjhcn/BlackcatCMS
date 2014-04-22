/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat;

public class SystemConstants {
	public static final int OPENING_TIMESTAMP = 1262304000;// 2010-01-01

	public static final String ADMIN_SESSION = "admin";

	public static final String UPLOAD_FOLDER_TEMP = "/home/blackcat/uploadfileTemp/";
	// public static final String UPLOAD_FOLDER_TEMP =
	// "/Users/haojunhua/JAVASpaces/J2EE project/blackcat/src/main/webapp/uploadfileTemp/";

	public static final String UPLOAD_FOLDER = "/home/blackcat/uploadfile/";
	// public static final String UPLOAD_FOLDER =
	// "/Users/haojunhua/JAVASpaces/J2EE project/blackcat/src/main/webapp/uploadfile/";

	public static final String BACKUP_FOLDER = "/home/blackcat/backup/";

	public static final String PATH = "blackcat/";

	public static final String[] ACCEPTED_PIC_EXT = { "jpg", "gif", "png", "bmp", "jpeg" };
	public static final String[] ACCEPTED_DOC_EXT = { "pdf", "doc", "docx", "ppt", "pptx", "xls",
			"xlsx" };
	public static final String[] ACCEPTED_SWF_EXT = { "swf", "flv" };
	public static final String[] ACCEPTED_AUDIO_EXT = { "mp3" };

	public static final float RATIO = 0.25f;

	public enum EXT_TYPE {
		ALL, PIC, DOC, SWF, AUDIO;
	}

	public class AUTHORITY {
		public static final int SUPER = 0;
		public static final int EDIT = 1;
		public static final int VIEW = 2;
	}

	public static final class STATUS {
		public static final short HANZI_DEFAULT = 0;
		public static final short HANZI_SELECTED = 1;
		public static final short HANZI_EDITED = 2;
		public static final short HANZI_VERIFY_NOTPASS = 3;
		public static final short HANZI_VERIFY_PASS = 4;

		public static final short CIYU_DEFAULT = 0;
		public static final short CIYU_VERIFY_NOTPASS = 1;
		public static final short CIYU_VERIFY_PASS = 2;
		public static final short CIYU_DELETED = 3;

		public static final short CIYU_GEN_THUMB_ERROR = -1;
		public static final short CIYU_GEN_THUMB_RUNING = 0;
		public static final short CIYU_GEN_THUMB_SUCCESS = 1;
	}

	public enum OPERATE {
		UPLOAD, EDIT, DELETE, VERIFY, UNVERIFY, SELECT_FOR_WEB;
	}

	public static final class FEEDBACK {
		public static final int SUCCESS = 100;
		public static final int UNKNOW_ERROR = -100;

		public static final int USER_LOGIN_ERROR = -101;
		public static final int USER_UID_ERROR = -102;// 用户Uid不存在
		public static final int USER_TOKEN_ERROR = -102;// 用户Uid不存在

		public static final int HANZI_ID_ERROR = -301;// 汉字id不存在
		public static final int HANZI_ZI_NOTEXSIT = -302;// 汉字限制开放
		public static final int HANZI_LIMITED = -303;// 汉字限制开放
        public static final int HANZI_ZUCUJU_PINYINYINDIAO_ERROR=-304; //组词句上传的拼音不在汉字拼音范围内

		public static final int CI_ID_ERROR = -401;// 词语ID错误
		public static final int CI_CI_EXSIT = -402;// 词语已存在
		public static final int CI_CI_ERROR = -403;// 词语已存在
		public static final int CI_ICON_ERROR = -404;// 图片错误
		public static final int CI_DELETED = -405;// 词语已被抛弃

		public static final int ADMIN_UNLOGIN_ERROR = -501;// 未登录错误
		public static final int ADMIN_USERNAME_NOTEXSIT = -502;// 管理用户名不存在
		public static final int ADMIN_LOGIN_PASW_ERROR = -503;// 登录密码错失败
		public static final int ADMIN_UID_NOTEXSIT = -504;// 管理员Uid不存在
		public static final int ADMIN_NEW_PASW_ERROR = -505;// 新密码格式错
		public static final int ADMIN_AUTH_ERROR = -506;// 权限错误

		public static final int UPLOADFILE_ID_NOEXSIT = -1201;
		public static final int UPLOADFILE_NOT_BELONG_TO_USER = -1202;
		public static final int UPLOADFILE_TYPE_ERROR = -1203;

	}

}
