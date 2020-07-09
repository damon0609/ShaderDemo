// jave.lin 2019.08.08
using UnityEngine;

public class TestMoveVertices : MonoBehaviour
{
    public Transform p0T;
    public Transform p1T;
    public Transform p2T;

    private Mesh mesh;

    public Transform target;

    // Start is called before the first frame update
    void Start()
    {
        mesh = GetComponent<MeshFilter>().mesh;
    }

    // Update is called once per frame
    void LateUpdate()
    {
        var o2w = this.gameObject.transform.localToWorldMatrix;     // 对象到世界
        var w2o = target.transform.worldToLocalMatrix;              // 世界到对象 
        // 先统一变换到世界空间
        var p0 = o2w.MultiplyPoint(mesh.vertices[0]); //先取平面上的三个顶点,将其转换成世界坐标
        var p1 = o2w.MultiplyPoint(mesh.vertices[1]);
        var p2 = o2w.MultiplyPoint(mesh.vertices[2]);

        // 再变换到对应的target模型的空间，因为我们shader中在模型空间中处理计算的
        p0T.position = w2o.MultiplyPoint(p0);
        p1T.position = w2o.MultiplyPoint(p1);
        p2T.position = w2o.MultiplyPoint(p2);
    }
}
