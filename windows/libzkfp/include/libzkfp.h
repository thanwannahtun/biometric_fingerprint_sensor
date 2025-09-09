#ifndef _libzkfp_h
#define _libzkfp_h
//#include "windowsx.h"
/**
*	@file		libzkfp.h
*	@brief		�ӿڶ���
*	@author		scar chen
*	@date		2016-04-12
*	@version	5.0
*	@par	��Ȩ��
*				ZKTeco
*	@par	��ʷ�汾			
*
*	@note
*
*/


#include "libzkfptype.h"


#ifdef __cplusplus
extern "C"
{
#endif

/**
	*	@brief	��ʼ����
	*	@param	:
	*		��
	*	@return
	*	����ֵ˵�����£�
	*	value			|	type		|	description of value
	*	----------------|---------------|-------------------------------
	*	0				|	int			|	�ɹ�
	*	����			|	int			|	ʧ��
	*	@note 
*/
ZKINTERFACE int APICALL ZKFPM_Init();

/**
	*	@brief	�ͷſ�
	*	@param	:
	*		��
	*	@return
	*	����ֵ˵�����£�
	*	value			|	type		|	description of value
	*	----------------|---------------|-------------------------------
	*	0				|	int			|	�ɹ�
	*	����			|	int			|	ʧ��
	*	@note 
*/
ZKINTERFACE int APICALL ZKFPM_Terminate();

/**
	*	@brief	��ȡ�豸��
	*	@param	:
	*		��
	*	@return
	*	����ֵ˵�����£�
	*		��ǰ����ָ�������豸��
	*	@note 
*/
ZKINTERFACE int APICALL ZKFPM_GetDeviceCount();


/**
		*	@brief	���豸
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	index			|	int			  |	[in]				|	�豸����
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	NULL			|	HANDLE		|	ʧ��
		*	����			|	HANDLE		|	�ɹ�
		*	@note 
	*/
	ZKINTERFACE HANDLE APICALL ZKFPM_OpenDevice(int index);

	/**
		*	@brief	�ر��豸
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDevice			|	HANDLE		  |	[in]				|	�豸����ʵ��ָ��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_CloseDevice(HANDLE hDevice);

	

	/**
		*	@brief	���ò���
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDevice			|	HANDLE		  |	[in]				|	�豸����ʵ��ָ��
		*	nParamCode		|	int			  |	[in]				|	��������
		*	paramValue		|	unsigned char*|	[in]				|	����ֵ
		*	cbParamValue	|	unsigned int  |	[in]				|	�������ݳ���
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_SetParameters(HANDLE hDevice, int nParamCode, unsigned char* paramValue, unsigned int cbParamValue);

	/**
		*	@brief	��ȡ����
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDevice			|	HANDLE		  |	[in]				|	�豸����ʵ��ָ��
		*	nParamCode		|	int			  |	[in]				|	��������
		*	paramValue		|	unsigned char*|	[out]				|	����ֵ
		*	cbParamValue	|	unsigned int* |	[out]				|	�������ݳ���
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_GetParameters(HANDLE hDevice, int nParamCode, unsigned char* paramValue, unsigned int* cbParamValue);
	
	/**
		*	@brief	��ȡָ��(ͼ��/ģ�壩
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDevice			|	HANDLE		  |	[in]				|	�豸����ʵ��ָ��
		*	fpImage			|	unsigned char*|	[out]				|	ָ��ͼ��
		*	cbFPImage		|	unsigned int  |	[in]				|	fpImage�ڴ��С
		*	fpTemplate		|	unsigned char*|	[out]				|	ָ��ģ��
		*	cbTemplate		|	unsigned int* |	[in/out]			|	ָ��ģ�峤��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_AcquireFingerprint(HANDLE hDevice, unsigned char* fpImage, unsigned int cbFPImage, unsigned char* fpTemplate, unsigned int* cbTemplate);


	/**
		*	@brief	��ȡָ��ͼ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDevice			|	HANDLE		  |	[in]				|	�豸����ʵ��ָ��
		*	fpImage			|	unsigned char*|	[out]				|	ָ��ͼ��
		*	cbFPImage		|	unsigned int  |	[in]				|	fpImage�ڴ��С
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_AcquireFingerprintImage(HANDLE hDevice, unsigned char* fpImage, unsigned int cbFPImage);

	/**
		*	@brief	�����㷨����ʵ��
		*	@param	:
		*	��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	NULL			|	HANDLE		|	ʧ��
		*	����			|	HANDLE		|	�ɹ�
		*	@note 
	*/
	ZKINTERFACE HANDLE APICALL ZKFPM_CreateDBCache();
	ZKINTERFACE HANDLE APICALL ZKFPM_DBInit();	//same as ZKFPM_CreateDBCache, for new version
	/**
		*	@brief	�ͷ��㷨����ʵ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_CloseDBCache(HANDLE hDBCache);
	ZKINTERFACE int APICALL ZKFPM_DBFree(HANDLE hDBCache); //same as ZKFPM_CloseDBCache, for new version

	ZKINTERFACE int APICALL ZKFPM_DBSetParameter(HANDLE hDBCache, int nParamCode, int paramValue);
	ZKINTERFACE int APICALL ZKFPM_DBGetParameter(HANDLE hDBCache, int nParamCode, int* paramValue);

	/**
		*	@brief	��3��ָ��ģ��ϳɵǼ�ģ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	temp1			|	unsigned char*|	[in]				|	ָ��ģ��1
		*	temp2			|	unsigned char*|	[in]				|	ָ��ģ��2
		*	temp3			|	unsigned char*|	[in]				|	ָ��ģ��3
		*	regTemp			|	unsigned char*|	[out]				|	�Ǽ�ģ��
		*	cbRegTemp		|	unsigned int* |	[in/out]			|	�Ǽ�ģ�峤��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_GenRegTemplate(HANDLE hDBCache, unsigned char* temp1, unsigned char* temp2, unsigned char* temp3, unsigned char* regTemp, unsigned int* cbRegTemp);
	ZKINTERFACE int APICALL ZKFPM_DBMerge(HANDLE hDBCache, unsigned char* temp1, unsigned char* temp2, unsigned char* temp3, unsigned char* regTemp, unsigned int* cbRegTemp);	//same as ZKFPM_GenRegTemplate, for new version
		
	/**
		*	@brief	���ָ��ģ�嵽����
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	fid				|	unsigned int  |	[in]				|	��ָID
		*	fpTemplate		|	unsigned char*|	[in]				|	ָ��ģ��
		*	cbTemplate		|	unsigned int  |	[in]				|	ָ��ģ�峤��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_AddRegTemplateToDBCache(HANDLE hDBCache, unsigned int fid, unsigned char* fpTemplate, unsigned int cbTemplate);
	ZKINTERFACE int APICALL ZKFPM_DBAdd(HANDLE hDBCache, unsigned int fid, unsigned char* fpTemplate, unsigned int cbTemplate);	//same as ZKFPM_AddRegTemplateToDBCache, for new version

	/**
		*	@brief	�ӻ���ɾ��ָ��ģ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	fid				|	unsigned int  |	[in]				|	��ָID
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_DelRegTemplateFromDBCache(HANDLE hDBCache, unsigned int fid);
	ZKINTERFACE int APICALL ZKFPM_DBDel(HANDLE hDBCache, unsigned int fid);			//same as ZKFPM_DelRegTemplateFromDBCache, for new version
	

	/**
		*	@brief	����㷨����
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_ClearDBCache(HANDLE hDBCache);
	ZKINTERFACE int APICALL ZKFPM_DBClear(HANDLE hDBCache);	//same as ZKFPM_ClearDBCache, for new version

	/**
		*	@brief	��ȡ����ģ����
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	fpCount			|	unsigned int* |	[out]				|	ָ��ģ����
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_GetDBCacheCount(HANDLE hDBCache, unsigned int* fpCount);
	ZKINTERFACE int APICALL ZKFPM_DBCount(HANDLE hDBCache, unsigned int* fpCount);	//same as ZKFPM_GetDBCacheCount, for new version


	/**
		*	@brief	ָ��ʶ��(1:N)
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	fpTemplate		|	unsigned char*|	[in]				|	ָ��ģ��
		*	cbTemplate		|	unsigned int  | [in]				|	ָ��ģ���С
		*	FID				|	unsigned int* |	[out]				|	ָ����ID
		*	score			|	unsigned int* |	[out]				|	����
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_Identify(HANDLE hDBCache, unsigned char* fpTemplate, unsigned int cbTemplate, unsigned int* FID, unsigned int* score);
	ZKINTERFACE int APICALL ZKFPM_DBIdentify(HANDLE hDBCache, unsigned char* fpTemplate, unsigned int cbTemplate, unsigned int* FID, unsigned int* score);	//same as ZKFPM_Identify, for new version


	/**
		*	@brief	�ȶ���öָ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	template1		|	unsigned char*|	[in]				|	ָ��ģ��1
		*	cbTemplate1		|	unsigned int  | [in]				|	ָ��ģ��1��С
		*	template2		|	unsigned char*|	[in]				|	ָ��ģ��2
		*	cbTemplate2		|	unsigned int  | [in]				|	ָ��ģ��2��С
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	>0				|	int			|	����
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_MatchFinger(HANDLE hDBCache, unsigned char* template1, unsigned int cbTemplate1, unsigned char* template2, unsigned int cbTemplate2);
	ZKINTERFACE int APICALL ZKFPM_DBMatch(HANDLE hDBCache, unsigned char* template1, unsigned int cbTemplate1, unsigned char* template2, unsigned int cbTemplate2); //same as ZKFPM_MatchFinger, for new version

	/**
		*	@brief	��Bitmap�ļ���ȡָ��ģ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	lpFilePathName	|	const char*   |	[in]				|	BMPͼƬ·��
		*	DPI				|	unsigned int  | [in]				|	BMPͼƬDPI
		*	fpTemplate		|	unsigned char*|	[out]				|	ָ��ģ��
		*	cbTemplate		|	unsigned int* |	[in/out]			|	ģ�峤��
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	>0				|	int			|	����
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_ExtractFromImage(HANDLE hDBCache, const char* lpFilePathName, unsigned int DPI, unsigned char* fpTemplate, unsigned int *cbTemplate);


	/**
		*	@brief	Base64�ַ���ת����������
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	src				|	const char*	  |	[in]				|	Base64�ַ���
		*	blob			|	unsigned char*|	[out]				|	���ض���������
		*	cbBlob			|	unsigned int  |	[in]				|	blob�ڴ��С
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	>0��ʾ���ݳ��ȣ�<=0��ʾʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_Base64ToBlob(const char* src, unsigned char* blob, unsigned int cbBlob);

	/**
		*	@brief	����������תBase64�ַ���
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	src				|const unsigned char*|	[in]			|	����������
		*	cbSrc			|	unsigned int  |	[in]				|	���������ݳ���
		*	base64Str		|	char *		  |	[out]				|	����Base64�ַ���
		*	cbBase64str		|	unsigned int  | [int]				|	base64Str�����ڴ��С
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	>0��ʾ���ݳ��ȣ�<=0��ʾʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_BlobToBase64(const unsigned char* src, unsigned int cbSrc, char* base64Str, unsigned int cbBase64str);


	/**
		*	@brief	1:1�ȶ��û�ָ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDBCache		|	HANDLE		  |	[in]				|	�㷨����ʵ��ָ��
		*	fpTemplate		|	unsigned char*|	[in]				|	ָ��ģ��
		*	cbTemplate		|	unsigned int  | [in]				|	ָ��ģ���С
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	>0				|	int			|	����
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_VerifyByID(HANDLE hDBCache, unsigned int fid, unsigned char* fpTemplate, unsigned int cbTemplate);

	/**
		*	@brief	��ȡ���һ���ⲿͼ������ָ��
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	width			|	int*		  |	[out]				|	ͼ���
		*	height			|	int*		  |	[out]				|	ͼ���
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	ͼ������ָ�룬����ZKFPM_ExtractFromImage�ɹ����ȡ
		*	@note 
	*/
	ZKINTERFACE unsigned char* APICALL ZKFPM_GetLastExtractImage(int * width, int* height);


	/**
		*	@brief	��ȡ�ɼ�����
		*	@param	:
		*	����˵�����±�
		*	name			|	type		  |	param direction		|	description of param
		*	----------------|-----------------|---------------------|------------------------
		*	hDevice			|	HANDLE		  |	[in]				|	�豸����ʵ��ָ��
		*	pCapParams		|	PZKFPCapParams|	[out]				|	�ɼ�����
		*	@return
		*	����ֵ˵�����£�
		*	value			|	type		|	description of value
		*	----------------|---------------|-------------------------------
		*	0				|	int			|	�ɹ�
		*	����			|	int			|	ʧ��
		*	@note 
	*/
	ZKINTERFACE int APICALL ZKFPM_GetCaptureParams(HANDLE hDevice, PZKFPCapParams pCapParams);

	ZKINTERFACE int APICALL ZKFPM_GetCaptureParamsEx(HANDLE hDevice, int* width, int* height, int* dpi);

#ifdef __cplusplus
};
#endif


#endif	//_libzkfp_h