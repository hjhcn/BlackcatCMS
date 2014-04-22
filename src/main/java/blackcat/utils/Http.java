/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.utils;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class Http {
	public static String getRemoteData(String apiUrl, String param, String contentType,
			String method) {
		StringBuilder sb = new StringBuilder();
		try {
			// 创建连接
			URL url = new URL(apiUrl);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod(method);
			connection.setUseCaches(false);
			connection.setInstanceFollowRedirects(true);

			connection.setRequestProperty("Content-Type", contentType);
			connection.connect();

			// POST请求
			DataOutputStream out = new DataOutputStream(connection.getOutputStream());
			out.writeBytes(param);
			out.flush();
			out.close();

			// 读取响应
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream(), "UTF-8"));
			String lines;
			while ((lines = reader.readLine()) != null) {
				sb.append(lines);
			}
			reader.close();
			// 断开连接
			connection.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sb.toString();

	}
}
