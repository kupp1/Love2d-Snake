--https://stackoverflow.com/questions/18843610/fast-implementation-of-queues-in-lua
queue = {}
  function queue.new()
    return {first = 0, last = -1}
  end

  function queue.push(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
  end

  function queue.pop(list)
    local first = list.first
    if first > list.last then error("queue is empty") end
    local value = list[first]
    list[first] = nil
    list.first = first + 1
    return value
  end

  function queue.getedges(list)
    return list.first, list.last
  end

  function queue.getn(list, n)
    if list.first <= list.last and n >= list.first and n <= list.last then
      return list[n]
    end
  end

  function queue.getlast(list)
    if list.first <= list.last then
      return list[list.last]
    end
  end

  function queue.getfirst(list)
    if list.first <= list.last then
      return list[list.first]
    end
  end
return queue