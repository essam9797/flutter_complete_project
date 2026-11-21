import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;
  bool _isNotificationOn = true;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings ⚙️',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 205, 212),
        elevation: 4.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(
              _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 38.r,
                      backgroundColor: Colors.indigo.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'User Name',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.edit, size: 16.sp, color: Colors.indigo),
                      label: Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 14.sp, color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Account Settings',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              leading: Icon(
                _isSoundOn ? Icons.volume_up : Icons.volume_off,
                color: _isSoundOn ? Colors.indigo : Colors.grey,
              ),
              title: Text(
                'Sound',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              trailing: Switch(
                value: _isSoundOn,
                activeThumbColor: Colors.indigo,
                activeTrackColor: Colors.indigo.withValues(alpha: 0.4),
                onChanged: (newValue) {
                  setState(() {
                    _isSoundOn = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              leading: Icon(
                _isVibrationOn ? Icons.vibration_outlined : Icons.smartphone,
                color: _isVibrationOn ? Colors.indigo : Colors.grey,
              ),
              title: Text(
                'Vibration',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              trailing: Switch(
                value: _isVibrationOn,
                activeThumbColor: Colors.indigo,
                activeTrackColor: Colors.indigo.withValues(alpha: 0.4),
                onChanged: (newValue) {
                  setState(() {
                    _isVibrationOn = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              leading: Icon(
                _isNotificationOn
                    ? Icons.notifications_active
                    : Icons.notification_important,
                color: _isNotificationOn ? Colors.indigo : Colors.grey,
              ),
              title: Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              trailing: Switch(
                value: _isNotificationOn,
                activeThumbColor: Colors.indigo,
                activeTrackColor: Colors.indigo.withValues(alpha: 0.4),
                onChanged: (newValue) {
                  setState(() {
                    _isNotificationOn = newValue;
                  });
                },
              ),
            ),
            Divider(
              thickness: 1.h,
              color: Colors.blueGrey.withValues(alpha: 0.2),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {},
              leading: Icon(Icons.privacy_tip_outlined, color: Colors.blueGrey),
              title: Text('Privacy Policy', style: TextStyle(fontSize: 16.sp)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey,
              ),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {},
              leading: Icon(Icons.description_outlined, color: Colors.blueGrey),
              title: Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 16.sp),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey,
              ),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {},
              leading: Icon(Icons.support_agent, color: Colors.blueGrey),
              title: Text('Contact Us', style: TextStyle(fontSize: 16.sp)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey,
              ),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {},
              leading: Icon(Icons.chat_bubble_outline, color: Colors.blueGrey),
              title: Text('Talk to support', style: TextStyle(fontSize: 16.sp)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
