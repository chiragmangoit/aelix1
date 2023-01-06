import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../providers/attendance_provider.dart';

class Calender extends StatefulWidget {
  final data;
  final classId;

  const Calender({Key? key, required this.data, required this.classId})
      : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  List<DateTime> blackoutDateList = [];

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    for (var attendanceData in widget.data) {
      var app = Appointment(
        startTime: DateTime.parse(attendanceData['date']),
        endTime: DateTime.parse(attendanceData['date']),
        color: attendanceData['attendance'] == null ||
                attendanceData['attendance'] == '0'
            ? Colors.red
            : Colors.green,
      );
      if (!appointments.contains(app)) {
        appointments.add(app);
      }
    }
    return _AppointmentDataSource(appointments);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setWeekend(DateTime.now().month, DateTime.now().year);
  }

  setWeekend(int month, int yearValue) {
    DateTime now = DateTime(yearValue, month, 1);
    late DateTime lastDayOfMonth;
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    for (var index = 0; index <= lastDayOfMonth.day; index++) {
      var currentDate = now.add(Duration(days: index + 1));
      if (index == 0) {
        currentDate = now;
      }
      final dateName = DateFormat('E').format(currentDate);
      if (dateName == 'Sat' || dateName == 'Sun') {
        blackoutDateList.add(currentDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 0.0,
            child: SfCalendar(
              todayTextStyle: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(0, 0, 0, 1)),
              firstDayOfWeek: 1,
              todayHighlightColor: Colors.transparent,
              headerStyle:
                  const CalendarHeaderStyle(textAlign: TextAlign.center),
              view: CalendarView.month,
              onViewChanged: (ViewChangedDetails viewChangedDetails) {
                SchedulerBinding.instance.addPostFrameCallback((duration) {
                  var selectedView = viewChangedDetails.visibleDates.first;
                  var now = DateTime(
                      selectedView.year, selectedView.month, selectedView.day);
                  var lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
                  setState(
                    () {
                      setWeekend(selectedView.month, selectedView.year);
                      var date = {
                        "toDate": DateFormat('yyyy-MM-dd')
                            .format(DateTime(selectedView.year,
                                selectedView.month, lastDayOfMonth))
                            .toString(),
                        "fromDate":
                            DateFormat('yyyy-MM-dd').format(now).toString()
                      };
                      Provider.of<Attendance>(context, listen: false)
                          .fetchAttendance(widget.classId, date);
                    },
                  );
                });
              },
              showNavigationArrow: true,
              monthViewSettings: MonthViewSettings(
                dayFormat: 'EEE',
                showTrailingAndLeadingDates: false,
                monthCellStyle: MonthCellStyle(
                  textStyle: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 1)),
                ),
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              ),
              dataSource: _getCalendarDataSource(),
              blackoutDates: blackoutDateList,
              blackoutDatesTextStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
