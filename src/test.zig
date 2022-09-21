const std = @import("std");
//const zigstr = @import("../deps/zigstr/src/Zigstr.zig");
const zigstr = @import("./zigstr/Zigstr.zig");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    var text1 = try zigstr.fromBytes(gpa, "Héllo there");
    defer text1.deinit();
    var text2 = try zigstr.fromBytes(gpa, "Héllo brah");
    defer text2.deinit();

    std.debug.print("common = {}\n", .{commonPrefix(text1, text2)});
    try foo();
}

fn commonPrefix(text1: zigstr, text2: zigstr) usize {

    // Quick check for common edge cases.
    if (text1.isEmpty() or text2.isEmpty() or text1.byteAt(0) catch {
        unreachable;
    } != text2.byteAt(0) catch {
        unreachable;
    }) {
        return 0;
    }
    return 1;
}

//test "common prefix edge cases" {
fn foo() !void {
    var text1 = try zigstr.fromBytes(gpa, "foo");
    defer text1.deinit();
    var text2 = try zigstr.fromBytes(gpa, "bar");
    defer text2.deinit();

    try expectEqual(commonPrefix(text1, text2), 1);
}
