using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaneTransform : MonoBehaviour
{
    // Start is called before the first frame update

    public Transform dirLightTrans;

    public float raidus = 1;

    private Mesh mesh;

    private Vector3 localVex0;
    private Vector3 localVex1;
    private Vector3 localVex2;


    private Vector3 worldVex0;
    private Vector3 worldVex1;
    private Vector3 worldVex2;

    public float angle;
    public float speed;
    private void OnDrawGizmos()
    {
        if (mesh == null)
        {
            mesh = transform.GetComponent<MeshFilter>().sharedMesh;
        }

        localVex0 = transform.rotation * mesh.vertices[0];
        localVex1 = transform.rotation * mesh.vertices[1];
        localVex2 = transform.rotation * mesh.vertices[mesh.vertices.Length - 1];

        Gizmos.color = Color.black;
        Gizmos.DrawSphere(localVex0, 0.01f);
        Gizmos.DrawSphere(localVex1, 0.01f);
        Gizmos.DrawSphere(localVex2, 0.01f);


        //绘制顶点法线(用物体的四元数变换顶点)
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(localVex0, transform.rotation * mesh.normals[0] + localVex0);
        Gizmos.DrawLine(localVex1, transform.rotation * mesh.normals[1] + localVex1);
        Gizmos.DrawLine(localVex2, transform.rotation * mesh.normals[2] + localVex2);


        //物体的矩阵变换物体顶点
        Matrix4x4 matrix = transform.localToWorldMatrix;
        Vector3 planeNormal = matrix * Vector3.up;//平面法线
        Vector3 originPos = matrix * (Vector3.zero);
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(originPos, 0.1f);
        Gizmos.DrawLine(originPos, planeNormal.normalized + originPos);
        Gizmos.DrawSphere(dirLightTrans.position, 0.1f);


        Vector3 lightDir = (originPos - dirLightTrans.position);//入手光线的方向
        float dis = Vector3.Distance(dirLightTrans.position, originPos);

        Gizmos.color = Color.red;
        Gizmos.DrawLine(originPos, originPos - lightDir.normalized * dis);//入射光线

        //--------------------求入射光线在平面的投影
        Vector3 shadowLight = matrix * (Vector3.right - originPos); //这里一定要记住使用的是向量有方向大小，不能之间用点否在方向不对

        float cosQ = Vector3.Dot(lightDir, shadowLight) / (lightDir.magnitude * shadowLight.magnitude);//投影向量的模长
        Vector3 shadowLight01 = shadowLight.normalized * (cosQ * lightDir.magnitude);//投影向量
        Gizmos.DrawLine(originPos, -shadowLight01 + originPos);
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(-shadowLight01 + originPos, 0.1f);




        //--------------------求反方向投影的末点到入射光线的距离 
        //根据两个向量叉乘的结果等于以这两个向量为边的三角形型的面积除以底边即可求出高
        float dis1 = Vector3.Cross(lightDir, shadowLight01).magnitude / lightDir.magnitude;

        Vector3 reverseLightDir = -lightDir;
        Vector3 reverseShadowDir = -shadowLight01;

        float cosQ1 = Vector3.Dot(reverseLightDir, reverseShadowDir) / (reverseShadowDir.magnitude * reverseLightDir.magnitude);
        float dist = reverseShadowDir.magnitude * cosQ1;
        Vector3 targetPos = reverseLightDir.normalized * dist; //注意这里一定要使用单位向量乘以距离

        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(targetPos + originPos, 0.1f);

        Vector3 shadowPos = -shadowLight01 + originPos;//向量平移点得出的结果是点
        Vector3 shadowPos01 = targetPos + originPos;//同上
        Vector3 shadowDir = shadowPos01 - shadowPos;
        Gizmos.DrawLine(shadowPos, shadowPos + shadowDir.normalized * dis1);





        //通过角度计算反射有问题
        // Vector3 reflection = (Quaternion.Euler(0, 0, angle) * planeNormal).normalized;
        // Gizmos.color = Color.black;
        // Gizmos.DrawLine(originPos, originPos + reflection * 2);
    }

    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        angle += Time.deltaTime * speed;
        Vector3 pos = new Vector3(Mathf.Cos(Mathf.Deg2Rad * angle)*raidus, Mathf.Sin(Mathf.Deg2Rad * angle)*raidus, 0);
        dirLightTrans.position = pos;
    }
}
