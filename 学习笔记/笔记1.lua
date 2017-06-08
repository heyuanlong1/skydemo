
1.skynet API  https://github.com/cloudwu/skynet/wiki/APIList

2.关于因阻塞导致的消息处理顺序问题  https://github.com/cloudwu/skynet/wiki/CriticalSection

3.使用gateServer的话 每个包就是 2 个字节 + 数据内容。这两个字节是 Big-Endian 编码的一个数字。数据内容可以是任意字节。
所以，单个数据包最长不能超过 65535 字节。如果业务层需要传输更大的数据块，请在上层业务协议中解决。

4.
在 skynet 中，用服务 (service) 这个概念来表达某项具体业务，它包括了处理业务的逻辑以及关联的数据状态。对，使用 skynet 实现游戏服务器时，不建议把业务状态同步到数据库中，而是存放在服务的内存数据结构里。服务、连同服务处理业务的逻辑代码和业务关联的状态数据，都是常驻内存的。如果数据库是你架构的一部分，那么大多数情况下，它扮演的是一个数据备份的角色。你可以在状态改变时，把数据推到数据库保存，也可以定期写到数据库备份。业务处理时直接使用服务内的内存数据结构。

5.
和 erlang 不同，一个 skynet 服务在某个业务流程被挂起后，即使回应消息尚未收到，它还是可以处理其他的消息的。所以同一个 skynet 服务可以同时拥有多条业务执行线。所以，你尽可以让同一个 skynet 服务处理很多消息，它们会看起来并行，和真正分拆到不同的服务中处理的区别是，这些处理流程永远不会真正的并行，它们只是在轮流工作。一段业务会一直运行到下一个 IO 阻塞点，然后切换到下一段逻辑。你可以利用这一点，让多条业务线在处理时共享同一组数据，这些数据在同一个 lua 虚拟机下时，读写起来都比通过消息交换要廉价的多。

6.
如果一条用户线程永远不调用阻塞 API 让出控制权，那么它将永远占据系统工作线程。skynet 并不是一个抢占式调度器，没有时间片的设计，不会因为一个工作线工作时间过长而强制挂起它。所以需要开发者自己小心，不要陷入死循环。不过，skynet 框架也做了一些监控工作，会在某个服务内的某个工作线程占据了太长时间后，以 log 的形式报告

7.
以 . 开头的名字是在同一 skynet 节点下有效的，跨节点的 skynet 服务对别的节点下的 . 开头的名字不可见。不同的 skynet 节点可以定义相同的 . 开头的名字。

8. https://github.com/cloudwu/skynet/wiki/Cluster
可以通过 cluster.call(nodename, service, ...) 提起请求。这里 nodename 就是在配置表中给出的节点名。service 可以是一个字符串，或者直接是一个数字地址（如果你能从其它渠道获得地址的话）。当 service 是一个字符串时，只需要是那个节点可以见到的服务别名，可以是全局名或本地名。但更推荐是 . 开头的本地名


9.
skynet.send(address, typename, ...) 这条 API 可以把一条类别为 typename 的消息发送给 address 。它会先经过事先注册的 pack 函数打包 ... 的内容。
skynet.send 是一条非阻塞 API ，发送完消息后，coroutine 会继续向下运行，这期间服务不会重入。

skynet.call(address, typename, ...) 这条 API 则不同，它会在内部生成一个唯一 session ，并向 address 提起请求，并阻塞等待对 session 的回应（可以不由 address 回应）。当消息回应后，还会通过之前注册的 unpack 函数解包。
尤其需要留意的是，skynet.call 仅仅阻塞住当前的 coroutine ，而没有阻塞整个服务。在等待回应期间，服务照样可以响应其他请求。所以，尤其要注意，在 skynet.call 之前获得的服务内的状态，到返回后，很有可能改变。

10.
skynet.redirect(address, source, typename, session, ...) 它和 skynet.send 功能类似，但更细节一些。它可以指定发送地址（把消息源伪装成另一个服务），指定发送的消息的 session 。注：address 和 source 都必须是数字地址，不可以是别名。skynet.redirect 不会调用 pack ，所以这里的 ... 必须是一个编码过的字符串，或是 userdata 加一个长度。

skynet.genid() 生成一个唯一 session 号。
skynet.rawcall(address, typename, message, size) 它和 skynet.call 功能类似（也是阻塞 API）。但发送时不经过 pack 打包流程，收到回应后，也不走 unpack 流程。

11.
skynet.start 注册一个函数为这个服务的启动函数。当然你还是可以在脚本中随意写一段 Lua 代码，它们会先于 start 函数执行。但是，不要在外面调用 skynet 的阻塞 API ，因为框架将无法唤醒它们。
如果你想在 skynet.start 注册的函数之前做点什么，可以调用 skynet.init(function() ... end) 。

skynet.exit() 用于退出当前的服务。
skynet.kill(address) 可以用来强制关闭别的服务。
skynet.newservice(name, ...) 用于启动一个新的 Lua 服务。
skynet.launch(servicename, ...)。


skynet.now() 将返回 skynet 节点进程启动的时间。
skynet.starttime() 返回 skynet 节点进程启动的 UTC 时间，以秒为单位。
skynet.time() 返回以秒为单位（精度为小数点后两位）的 UTC 时间。它时间上等价于：skynet.now()/100 + skynet.starttime()
skynet.sleep(ti) 将当前 coroutine 挂起 ti 个单位时间。一个单位是 1/100 秒。
skynet.yield() 相当于 skynet.sleep(0) 。交出当前服务对 CPU 的控制权。
skynet.timeout(ti, func) 让框架在 ti 个单位时间后，调用 func 这个函数.
skynet.fork(func, ...)
skynet.wait() 把当前 coroutine 挂起。通常这个函数需要结合 skynet.wakeup 使用。
skynet.wakeup(co) 唤醒一个被 skynet.sleep 或 skynet.wait 挂起的 coroutine 。



12 socket api
https://github.com/cloudwu/skynet/wiki/Socket

13.
skynet.uniqueservice 和 skynet.newservice 的输入参数相同，都可以以一个脚本名称找到一段 lua 脚本并启动它，返回这个服务的地址。但和 newservice 不同，每个名字的脚本在同一个 skynet 节点只会启动一次。如果已有同名服务启动或启动中，后调用的人获得的是前一次启动的服务的地址。
默认情况下，uniqueservice 是不跨节点的。





{
	https://github.com/forthxu/talkbox
	有注册消息（skynet.register_protocol {}）的示例 

	https://github.com/greathqy/mud_build_on_skynet
	给agent做个池

	https://github.com/fztcjjl/metoo
	
}






