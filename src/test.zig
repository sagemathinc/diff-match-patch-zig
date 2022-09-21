const std = @import("std");
const zigstr = @import("../deps/zigstr/src/Zigstr.zig");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    var str = try zigstr.fromBytes(gpa, "Héllo");
    defer str.deinit();

    std.debug.print("hello, {}, {}\n", .{ str.byteCount(), str });
}
