import java.util {
    List,
    ArrayList
}

List<Out> transform<In,Out>(List<out In> input, Out(In) transformer) {
    value result = ArrayList<Out>(input.size());
    
    for (i in input) {
        result.add(transformer(i));
    }
    
    return result;
}