class TimeSlotModel {
  bool? status;
  String? msg;
  Data? data;

  TimeSlotModel({this.status, this.msg, this.data});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<TimeSlot>? timeSlot;

  Data({this.timeSlot});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['time_slot'] != null) {
      timeSlot = <TimeSlot>[];
      json['time_slot'].forEach((v) {
        timeSlot!.add(new TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timeSlot != null) {
      data['time_slot'] = this.timeSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {
  String? day;
  String? date;
  List<Slot>? slot;

  TimeSlot({this.day, this.date, this.slot});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slot {
  String? slotType;
  List<SlotTime>? slotTime;

  Slot({this.slotType, this.slotTime});

  Slot.fromJson(Map<String, dynamic> json) {
    slotType = json['slot_type'];
    if (json['slot_time'] != null) {
      slotTime = <SlotTime>[];
      json['slot_time'].forEach((v) {
        slotTime!.add(new SlotTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_type'] = this.slotType;
    if (this.slotTime != null) {
      data['slot_time'] = this.slotTime!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotTime {
  String? time;
  int? charges;
  bool? isActive;

  SlotTime({this.time, this.charges, this.isActive});

  SlotTime.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    charges = json['charges'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['charges'] = this.charges;
    data['isActive'] = this.isActive;
    return data;
  }
}