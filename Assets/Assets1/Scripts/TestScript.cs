// jave.lin 2019.08.08
using UnityEngine;

public class TestScript : MonoBehaviour
{
    private int p0Hash;
    private int upDirHash;

    private Material mat;

    private Vector3 upDir;

    public Vector3 p0;

    public TestMoveVertices verticeObj;
    // Start is called before the first frame update
    void Start()
    {
        mat = this.GetComponent<MeshRenderer>().material;

        p0Hash = Shader.PropertyToID("p0");
        upDirHash = Shader.PropertyToID("upDir");
    }



    // Update is called once per frame
    void FixedUpdate() // 这里使用FixedUpdate不然一直抖动
    {
        p0 = verticeObj.p0T.transform.position;
        var p1 = verticeObj.p1T.transform.position;
        var p2 = verticeObj.p2T.transform.position;

        upDir = Vector3.Cross(p1 - p0, p2 - p0).normalized; //求平面的法向量

        mat.SetVector(p0Hash, p0);          // 传入平面的某个点
        mat.SetVector(upDirHash, upDir);    // 传入平面法线
    }

    private void OnDrawGizmos()
    {
        Gizmos.DrawSphere(p0,0.1f);
        Gizmos.color = Color.red;
        Gizmos.DrawLine(p0,p0+upDir.normalized);
    }
}
